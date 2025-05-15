# Stage 1: Build React App
FROM node:18-alpine AS builder
WORKDIR /app

# Install dependencies with cache leverage
COPY package*.json ./
RUN npm ci --only=production

# Copy app source and build
COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
