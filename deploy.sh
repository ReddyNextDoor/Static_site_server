#!/bin/bash

# Static Site Deployment Script using rsync
# This script deploys the local static site to the remote server

set -e  # Exit on any error

# Configuration
LOCAL_SITE_DIR="./site/"
REMOTE_USER="deploy"
REMOTE_HOST="localhost"
REMOTE_PORT="2222"
REMOTE_DIR="/var/www/html/"
SSH_KEY_PATH="$HOME/.ssh/id_rsa"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if server is reachable
check_server() {
    print_status "Checking server connectivity..."
    if ssh -p $REMOTE_PORT -o ConnectTimeout=10 -o BatchMode=yes $REMOTE_USER@$REMOTE_HOST exit 2>/dev/null; then
        print_status "Server is reachable"
        return 0
    else
        print_error "Cannot connect to server. Make sure:"
        echo "  1. Docker containers are running"
        echo "  2. SSH keys are properly configured"
        echo "  3. Server is accessible on $REMOTE_HOST:$REMOTE_PORT"
        return 1
    fi
}

# Function to setup SSH key if it doesn't exist
setup_ssh() {
    if [ ! -f "$SSH_KEY_PATH" ]; then
        print_warning "SSH key not found. Generating new key pair..."
        ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -C "deploy@static-site"
        print_status "SSH key generated at $SSH_KEY_PATH"
    fi
    
    # Copy public key to server (for initial setup)
    if [ ! -f "ssh-config/authorized_keys" ]; then
        mkdir -p ssh-config
        cp "${SSH_KEY_PATH}.pub" ssh-config/authorized_keys
        print_status "Public key copied to ssh-config/authorized_keys"
        print_warning "Please restart Docker containers to apply SSH key changes"
    fi
}

# Function to perform the deployment
deploy_site() {
    print_status "Starting deployment..."
    
    # Check if local site directory exists
    if [ ! -d "$LOCAL_SITE_DIR" ]; then
        print_error "Local site directory '$LOCAL_SITE_DIR' not found!"
        exit 1
    fi
    
    # Perform rsync deployment
    print_status "Syncing files to remote server..."
    
    rsync -avz --delete \
        -e "ssh -p $REMOTE_PORT -o StrictHostKeyChecking=no" \
        "$LOCAL_SITE_DIR" \
        "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"
    
    if [ $? -eq 0 ]; then
        print_status "Deployment completed successfully!"
        print_status "Site is available at: http://$REMOTE_HOST:8080"
    else
        print_error "Deployment failed!"
        exit 1
    fi
}

# Function to show deployment status
show_status() {
    print_status "Deployment Status:"
    echo "  Local site: $LOCAL_SITE_DIR"
    echo "  Remote server: $REMOTE_USER@$REMOTE_HOST:$REMOTE_PORT"
    echo "  Remote directory: $REMOTE_DIR"
    echo "  Site URL: http://$REMOTE_HOST:8080"
    echo ""
}

# Main execution
main() {
    echo "========================================="
    echo "  Static Site Deployment with rsync"
    echo "========================================="
    echo ""
    
    show_status
    
    # Setup SSH if needed
    setup_ssh
    
    # Check server connectivity
    if ! check_server; then
        print_error "Server check failed. Aborting deployment."
        exit 1
    fi
    
    # Deploy the site
    deploy_site
    
    echo ""
    print_status "Deployment process completed!"
}

# Handle command line arguments
case "${1:-deploy}" in
    "deploy")
        main
        ;;
    "status")
        show_status
        check_server
        ;;
    "setup-ssh")
        setup_ssh
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  deploy     Deploy the site (default)"
        echo "  status     Show deployment status and check connectivity"
        echo "  setup-ssh  Setup SSH keys"
        echo "  help       Show this help message"
        ;;
    *)
        print_error "Unknown command: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac