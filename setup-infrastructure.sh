#!/bin/bash

# MEAN Stack Infrastructure Setup Script
# This script sets up the complete infrastructure repository with submodules

echo "🚀 Setting up MEAN Stack Infrastructure..."

# Step 1: Create directory structure
echo "📁 Creating directory structure..."
mkdir -p infra/mongodb
mkdir -p infra/nginx

# Step 2: Add existing repos as submodules
echo "📦 Adding backend and frontend as submodules..."
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Updating submodules to branch: $CURRENT_BRANCH"

git submodule foreach "git checkout $CURRENT_BRANCH || echo 'Branch $CURRENT_BRANCH not found in submodule'"
git submodule update --remote --merge

# Step 3: Create .gitignore
echo "📝 Creating .gitignore..."
cat > .gitignore << 'EOF'
# Environment variables
.env

# Node modules
node_modules/
backend/node_modules/
frontend/node_modules/

# Logs
*.log
npm-debug.log*

# OS files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Docker
.docker/

# Build files
backend/dist/
frontend/dist/
EOF

# Step 4: Create MongoDB init script
echo "🗄️ Creating MongoDB initialization script..."
cat > infra/mongodb/init-mongo.js << 'EOF'
db = db.getSiblingDB('meandb');

db.createCollection('users');
db.createCollection('posts');

db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ username: 1 }, { unique: true });
db.posts.createIndex({ createdAt: -1 });
db.posts.createIndex({ author: 1 });

print('MongoDB initialized successfully');
EOF

# Step 5: Create Nginx config
echo "🌐 Creating Nginx configuration..."
cat > infra/nginx/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:3000;
    }

    upstream frontend {
        server frontend:4200;
    }

    server {
        listen 80;
        server_name localhost;

        location / {
            proxy_pass http://frontend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_cache_bypass $http_upgrade;
        }

        location /api {
            proxy_pass http://backend;
            proxy_http_