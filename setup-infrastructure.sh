#!/bin/bash

# MEAN Stack Infrastructure Setup Script
# This script sets up the complete infrastructure repository with submodules

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

echo "✅ Infrastructure setup complete!"
echo "📋 Next steps:"
echo "   1. Verify infra/mongodb/init-mongo.js exists"
echo "   2. Verify infra/nginx/nginx.conf exists"
echo "   3. Run: docker-compose up --build"
echo "   4. Access the application at http://localhost"