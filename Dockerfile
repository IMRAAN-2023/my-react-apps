# Stage 1: Build React app
FROM node:18-alpine AS build
WORKDIR /app

# Only copy package files first to leverage Docker layer caching
COPY package*.json ./

# Use npm ci for faster, reproducible installs
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy built React files
COPY --from=build /app/build /usr/share/nginx/html

# Optional: Add custom nginx config (if needed)
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
