# Use the official Node.js 14 image as a base image
FROM node:14-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Copy the rest of the application code to the container
COPY . .

# Install the application's dependencies inside the container
RUN npm install && npm run build

# # Exposing Port to the container
# EXPOSE 3000

# # Specify the command to run when the container starts
# CMD [ "npm", "start" ]


# Stage 2: Serve with NGINX
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]