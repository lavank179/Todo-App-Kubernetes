#!/bin/bash

set -e

APP_DIR=$(cd "$(dirname "$0")" && pwd)

VENV_DIR="$APP_DIR/.venv"
REQ_FILE="$APP_DIR/requirements.txt"
PY_FILE="$APP_DIR/main.py"

PYTHON_BIN=${PYTHON_BIN:-"python3.10-venv"}

ACTION=${1:-start}

#########################################
# Ensure python venv support exists
#########################################

ensure_venv_support() {

if ! $PYTHON_BIN -m venv --help >/dev/null 2>&1; then
    echo "python venv not available."

    if command -v apt >/dev/null; then
        echo "Installing python3-venv..."
        sudo apt update
        sudo apt install -y python3-venv
    else
        echo "Install python venv support manually."
        exit 1
    fi
fi

}

#########################################
# Create environment
#########################################

create_env() {

ensure_venv_support

if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

echo "Installing dependencies..."
pip install --upgrade pip
pip install -r "$REQ_FILE"

}

#########################################
# Delete environment
#########################################

clean_env() {

if [ -d "$VENV_DIR" ]; then
    echo "Removing virtual environment..."
    rm -rf "$VENV_DIR"
else
    echo "No virtual environment found."
fi

}

#########################################
# Run server
#########################################

run_server() {

if [ ! -d "$VENV_DIR" ]; then
    create_env
fi

source "$VENV_DIR/bin/activate"

echo "Starting Python server..."
exec python "$PY_FILE"

}

#########################################
# Action handler
#########################################

case "$ACTION" in

start)
    run_server
    ;;

install)
    create_env
    ;;

clean)
    clean_env
    ;;

reset)
    clean_env
    create_env
    run_server
    ;;

*)
    echo "Usage: $0 [start|install|clean|reset]"
    exit 1
    ;;

esac