MEAN Stack Infrastructure Setup Guide
Step-by-Step Setup with Git Submodules
1. Create New Repository on GitHub

Go to GitHub
Click "New Repository"
Name it: mean-stack-infra
Description: "Infrastructure setup for MEAN stack course project"
Keep it Public (or Private)
✅ Check "Add a README file"
Click "Create repository"

2. Clone and Setup Locally
bash# Clone your new infrastructure repo
git clone https://github.com/bormoley1983/mean-stack-infra.git
cd mean-stack-infra

# Add your existing repos as submodules
git submodule add https://github.com/bormoley1983/MEAN-Backend.git backend
git submodule add https://github.com/bormoley1983/MEAN-Frontend.git frontend

# Commit the submodules
git commit -m "Add backend and frontend as submodules"
git push
3. Create Infrastructure Files
Create these files in the root of mean-stack-infra:
Create docker-compose.yml
bash# Copy the docker-compose.yml content I provided earlier
notepad docker-compose.yml  # Windows
nano docker-compose.yml     # Mac/Linux
Create .env.example
bashnotepad .env.example
Create directories and files
bash# Create directory structure
mkdir -p infra/mongodb
mkdir -p infra/nginx

# Create MongoDB init script
notepad infra/mongodb/init-mongo.js

# Create Nginx config
notepad infra/nginx/nginx.conf

# Create .gitignore
notepad .gitignore
4. Add Dockerfiles to Backend and Frontend
bash# Go to backend submodule
cd backend

# Create Dockerfile (copy the Backend Dockerfile content I provided)
notepad Dockerfile

# Commit to backend repo
git add Dockerfile
git commit -m "Add Dockerfile for containerization"
git push

# Go back and do the same for frontend
cd ../frontend
notepad Dockerfile
git add Dockerfile
git commit -m "Add Dockerfile for containerization"
git push

# Go back to root
cd ..
5. Update Parent Repository
bash# Update submodule references
git submodule update --remote

# Add all new files
git add .

# Commit everything
git commit -m "Add Docker infrastructure and configuration"

# Push to GitHub
git push origin main
6. Create Environment File
bash# Copy template to actual .env file
cp .env.example .env

# Edit with your settings
notepad .env
7. Start Everything
bash# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
For Your Team/Future You
When someone else (or future you) wants to clone everything:
bash# Clone with all submodules in one command
git clone --recursive https://github.com/bormoley1983/mean-stack-infra.git

cd mean-stack-infra

# Setup environment
cp .env.example .env

# Start
docker-compose up -d
Working on Individual Projects
Working on Backend
bashcd backend
git checkout main
git pull

# Make changes...
npm install
npm run dev

# Commit and push to MEAN-Backend repo
git add .
git commit -m "Your changes"
git push
Working on Frontend
bashcd frontend
git checkout main
git pull

# Make changes...
npm install
npm start

# Commit and push to MEAN-Frontend repo
git add .
git commit -m "Your changes"
git push
Update Infrastructure to Latest Versions
bash# In the root mean-stack-infra folder
git submodule update --remote --merge

# Commit the updated references
git add backend frontend
git commit -m "Update backend and frontend to latest versions"
git push
Repository Structure
After setup, you'll have:
GitHub Repositories:
├── bormoley1983/MEAN-Backend        (existing - your backend code)
├── bormoley1983/MEAN-Frontend       (existing - your frontend code)
└── bormoley1983/mean-stack-infra    (new - infrastructure)
    ├── backend/                     (submodule → MEAN-Backend)
    ├── frontend/                    (submodule → MEAN-Frontend)
    ├── docker-compose.yml
    ├── .env.example
    ├── .gitignore
    ├── infra/
    │   ├── mongodb/
    │   │   └── init-mongo.js
    │   └── nginx/
    │       └── nginx.conf
    └── README.md
CI/CD Deployment
Each repository can have its own GitHub Actions:
MEAN-Backend: .github/workflows/docker-build.yml
yamlname: Build Backend Docker Image
on:
  push:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build Docker image
        run: docker build -t mean-backend .
MEAN-Frontend: .github/workflows/docker-build.yml
yamlname: Build Frontend Docker Image
on:
  push:
    branches: [main]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build Docker image
        run: docker build -t mean-frontend .
Quick Commands Reference
bash# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild and restart
docker-compose up -d --build

# Update submodules
git submodule update --remote

# Access MongoDB
docker exec -it mean-mongodb mongosh

# Access backend container
docker exec -it mean-backend sh

# Access frontend container
docker exec -it mean-frontend sh
Troubleshooting
Submodules not cloned
bashgit submodule update --init --recursive
Changes not showing in submodules
bashcd backend  # or frontend
git pull origin main
Port conflicts
bash# Stop all containers
docker-compose down

# Check what's using ports
netstat -ano | findstr :3000
netstat -ano | findstr :4200
netstat -ano | findstr :27017