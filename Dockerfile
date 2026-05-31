# ---------- Build stage ----------
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy frontend source code
COPY . .

# Replace API URL placeholder before Angular build
ARG FRONTEND_API_URL
RUN sed -i "s|__FRONTEND_API_URL__|${FRONTEND_API_URL}|g" src/environments/environment.ts

# Build Angular application
RUN npm run build


# ---------- Runtime stage ----------
FROM nginx:alpine

# Copy build output into NGINX
COPY --from=builder /app/dist/angular-conduit /usr/share/nginx/html

# Expose frontend port
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]