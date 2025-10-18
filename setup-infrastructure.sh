#!/bin/bash

# MEAN Stack Infrastructure Setup Script
# This script sets up the complete infrastructure repository with submodules and Docker containers

echo "🚀 Setting up MEAN Stack Infrastructure..."

# Step 1: Create directory structure
echo "📁 Creating directory structure..."
mkdir -p infra/mongodb
mkdir -p infra/nginx

# Step 2: Get current branch and add submodules with branch tracking
echo "📦 Adding backend and frontend as submodules..."
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: $CURRENT_BRANCH"

git submodule add -b $CURRENT_BRANCH https://github.com/bormoley1983/MEAN-Backend.git backend 2>/dev/null || echo "Backend submodule already exists"
git submodule add -b $CURRENT_BRANCH https://github.com/bormoley1983/MEAN-Frontend.git frontend 2>/dev/null || echo "Frontend submodule already exists"

# Update submodules to the current branch
echo "🔄 Updating submodules to branch: $CURRENT_BRANCH"
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
frontend/build/

# Docker volumes
mongodb_data/
EOF

# Step 4: Create MongoDB init script
echo "🗄️ Creating MongoDB initialization script..."
cat > infra/mongodb/init-mongo.js << 'EOF'
db = db.getSiblingDB('mean_demo');

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
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

        location /images {
            alias /usr/share/nginx/html/images;
            expires 30d;
        }
    }
}
EOF

echo "✅ Infrastructure setup complete!"
echo "📋 Next steps:"
echo "   1. Update backend and frontend Dockerfiles if needed"
echo "   2. Run: docker-compose up --build"
echo "   3. Access the application at http://localhost"