#!/bin/bash

set -e

############################################
# Config (override via env)
############################################

DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}

DB_ADMIN_USER=${DB_ADMIN_USER:-postgres}
DB_ADMIN_PASSWORD=${DB_ADMIN_PASSWORD:-keysecret}

APP_DB=${APP_DB:-todo_app}
APP_DB_USER=${APP_DB_USER:-admin}
APP_DB_PASSWORD=${APP_DB_PASSWORD:-adminpass}

COMPOSE_FILE=${COMPOSE_FILE:-docker-compose.yml}

ACTION=${1:-up}

############################################
# Derived URLs
############################################

DB_ADMIN_URL="postgres://${DB_ADMIN_USER}:${DB_ADMIN_PASSWORD}@${DB_HOST}:${DB_PORT}/postgres"
DB_APP_URL="postgres://${APP_DB_USER}:${APP_DB_PASSWORD}@${DB_HOST}:${DB_PORT}/${APP_DB}"

############################################
# DOWN
############################################

if [ "$ACTION" = "down" ]; then
  echo "Stopping containers..."
  docker compose -f "$COMPOSE_FILE" down
  exit 0
fi

if [ "$ACTION" = "restart-nondb" ]; then
  echo "Stopping nondb containers..."
  docker compose -f "$COMPOSE_FILE" down todo-backend todo-frontend
  echo "Starting nondb containers..."
  docker compose -f "$COMPOSE_FILE" up -d todo-backend todo-frontend
  exit 0
fi

if [ "$ACTION" = "recreate-nondb" ]; then
  echo "Stopping nondb containers..."
  docker compose -f "$COMPOSE_FILE" down todo-backend todo-frontend
  echo "Starting nondb containers..."
  docker compose -f "$COMPOSE_FILE" up -d --build todo-backend todo-frontend
  exit 0
fi

############################################
# START POSTGRES
############################################

echo "Starting postgres container..."

docker compose -f "$COMPOSE_FILE" up -d postgres

############################################
# WAIT FOR POSTGRES
############################################

echo "Waiting for postgres..."

until PGPASSWORD=$DB_ADMIN_PASSWORD \
  pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_ADMIN_USER"
do
  sleep 2
done

echo "Postgres ready."

############################################
# CREATE DATABASE (if missing)
############################################

echo "Checking database..."

DB_EXISTS=$(PGPASSWORD=$DB_ADMIN_PASSWORD \
  psql "$DB_ADMIN_URL" -tAc \
  "SELECT 1 FROM pg_database WHERE datname='$APP_DB'")

if [ "$DB_EXISTS" != "1" ]; then
  echo "Creating database $APP_DB"
  PGPASSWORD=$DB_ADMIN_PASSWORD \
  psql "$DB_ADMIN_URL" -c "CREATE DATABASE $APP_DB"
else
  echo "Database exists"
fi

############################################
# CREATE USER (if missing)
############################################

USER_EXISTS=$(PGPASSWORD=$DB_ADMIN_PASSWORD \
  psql "$DB_ADMIN_URL" -tAc \
  "SELECT 1 FROM pg_roles WHERE rolname='$APP_DB_USER'")

if [ "$USER_EXISTS" != "1" ]; then
  echo "Creating user $APP_DB_USER"
  PGPASSWORD=$DB_ADMIN_PASSWORD \
  psql "$DB_ADMIN_URL" -c \
  "CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASSWORD'"
else
  echo "User exists"
fi

############################################
# GRANT PRIVILEGES
############################################

echo "Granting privileges..."

PGPASSWORD=$DB_ADMIN_PASSWORD psql -h localhost -p 5432 -U "$DB_ADMIN_USER" "$DB_ADMIN_URL" -c \
"GRANT ALL PRIVILEGES ON DATABASE $APP_DB TO $APP_DB_USER"

PGPASSWORD=$DB_ADMIN_PASSWORD psql -h localhost -p 5432 -U "$DB_ADMIN_USER" "$DB_ADMIN_URL" -d "$APP_DB" <<EOF
GRANT USAGE ON SCHEMA public TO $APP_DB_USER;
GRANT CREATE ON SCHEMA public TO $APP_DB_USER;
ALTER SCHEMA public OWNER TO $APP_DB_USER;
EOF

############################################
# MIGRATION TABLE
############################################

PGPASSWORD=$APP_DB_PASSWORD \
psql "$DB_APP_URL" <<EOF
CREATE TABLE IF NOT EXISTS schema_migrations (
    version TEXT PRIMARY KEY
);
EOF

############################################
# RUN MIGRATIONS
############################################

echo "Running migrations..."

for file in database/migrations/*.sql
do
  version=$(basename "$file")

  applied=$(PGPASSWORD=$APP_DB_PASSWORD \
    psql "$DB_APP_URL" -tAc \
    "SELECT 1 FROM schema_migrations WHERE version='$version'")

  if [ "$applied" = "1" ]; then
    echo "$version already applied"
  else
    echo "Applying $version"
    PGPASSWORD=$APP_DB_PASSWORD \
      psql "$DB_APP_URL" -f "$file"

    PGPASSWORD=$APP_DB_PASSWORD \
      psql "$DB_APP_URL" -c \
      "INSERT INTO schema_migrations VALUES ('$version')"
  fi
done

if [ "$ACTION" = "onlydb" ]; then
  exit 0
fi

############################################
# START ALL CONTAINERS
############################################

echo "Starting application containers..."

docker compose -f "$COMPOSE_FILE" up -d

echo "Deployment complete."