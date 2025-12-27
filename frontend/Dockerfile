# Stage 1: Build React app
FROM node:14-alpine AS builder

WORKDIR /app

# 1️⃣ Copy only dependency files first (CRITICAL)
COPY package.json ./

# 2️⃣ Install dependencies (cached unless deps change)
RUN npm install

# 3️⃣ Copy the rest of the source code
COPY . .

# 4️⃣ Build the app
RUN npm run build


# Stage 2: Serve with NGINX
FROM nginx:stable-alpine

# Copy built app
COPY --from=builder /app/build /usr/share/nginx/html

# Copy nginx template
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

CMD ["nginx", "-g", "daemon off;"]
