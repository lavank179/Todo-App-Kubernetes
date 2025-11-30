# Use the official Node.js 14 image as a base image
FROM node:14-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY . .

# Install the application's dependencies inside the container
RUN npm install && npm run build

# # Exposing Port to the container
# EXPOSE 3000

# # Specify the command to run when the container starts
# CMD [ "npm", "start" ]


# Stage 2: Serve with NGINX
FROM nginx:stable-alpine

# Copy built app
COPY --from=builder /app/build /usr/share/nginx/html

# Copy nginx template
COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# Set default backend URL if not provided
ENV BACKEND_URL=http://host.docker.internal:8881

# NGINX will automatically substitute env vars from /etc/nginx/templates/*.template
# and place the result in /etc/nginx/conf.d/
CMD ["nginx", "-g", "daemon off;"]