#!/bin/bash

# Setup script for Static Site Server with Nginx and rsync deployment

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "========================================="
echo "  Static Site Server Setup"
echo "========================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_warning "Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    print_warning "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

print_status "Starting Docker containers..."
docker-compose up -d

print_status "Waiting for containers to be ready..."
sleep 10

print_status "Setting up SSH keys..."
./deploy.sh setup-ssh

print_status "Containers are starting up. This may take a moment..."
sleep 5

print_status "Setup completed!"
echo ""
echo "Next steps:"
echo "1. Run './deploy.sh' to deploy your site"
echo "2. Visit http://localhost:8080 to see your site"
echo "3. SSH access: ssh -p 2222 deploy@localhost (password: password123)"
echo ""
echo "Available commands:"
echo "  ./deploy.sh         - Deploy the site"
echo "  ./deploy.sh status  - Check deployment status"
echo "  docker-compose logs - View container logs"
echo "  docker-compose down - Stop containers"