# MEAN Stack Infrastructure

Complete Docker-based infrastructure for MEAN stack applications with MongoDB, Nginx, backend, and frontend services.

## Prerequisites

- Docker & Docker Compose installed
- Git with submodule support

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/bormoley1983/MEAN-infra.git
cd MEAN-infra
```

### OPTIONAL. Run Setup Script

```bash
chmod +x setup-infrastructure.sh
./setup-infrastructure.sh
```

This will:
- Create directory structure
- Add backend and frontend as submodules (tracking current branch)
- Generate `.gitignore`, MongoDB init scripts, and Nginx config

### 2. Build and Start Containers

```bash
docker-compose up --build
```

## Services

| Service | Port | Description |
|---------|------|-------------|
| **Nginx** | 80 | Reverse proxy & load balancer |
| **Frontend** | 4200 | Angular application |
| **Backend** | 3000 | Node.js/Express API |
| **MongoDB** | 27017 | Database |

## Access Points

- **Application**: http://localhost
- **API**: http://localhost/api
- **Angular**: http://localhost/images

## Environment Variables

Backend environment variables (defined in `docker-compose.yml`):

```
MONGO_URL=mongodb://mongodb:27017/mean_demo
JWT_KEY=secret_passsphrase
NODE_ENV=production
PORT=3000
```

## Updating Submodules

To pull latest changes from backend/frontend submodules:

```bash
git submodule update --remote --merge
```

To switch branches across all submodules:

```bash
./setup-infrastructure.sh
```

## Stopping Services

```bash
docker-compose down
```

To remove volumes and start fresh:

```bash
docker-compose down -v
```

## Directory Structure

```
MEAN-infra/
├── backend/                    # Backend submodule
├── frontend/                   # Frontend submodule
├── infra/
│   ├── mongodb/
│   │   └── init-mongo.js      # MongoDB initialization script
│   └── nginx/
│       └── nginx.conf         # Nginx configuration
├── docker-compose.yml         # Docker Compose configuration
├── setup-infrastructure.sh    # Setup script
└── README.md                  # This file
```

## Notes

- Ensure backend and frontend have `Dockerfile` in their root directories
- MongoDB data persists in the `mongodb_data` volume
- All services run on the `mean-network` bridge network
- Backend images are shared with Nginx for static file serving