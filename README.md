# Static Site Server with Nginx and rsync Deployment

This project demonstrates how to set up a web server using Nginx to serve a static site, with automated deployment using rsync over SSH. The entire setup runs in Docker containers for easy development and testing.

## Features

- **Docker-based Linux server** - Complete server environment in containers
- **SSH connectivity** - Secure remote access for deployment
- **Nginx web server** - High-performance static file serving
- **Static website** - HTML, CSS, JavaScript, and images
- **rsync deployment** - Automated file synchronization
- **Comprehensive testing** - Full test suite for validation

## Project Structure

```
├── docker-compose.yml      # Docker services configuration
├── nginx.conf             # Nginx server configuration
├── site/                  # Static website files
│   ├── index.html        # Main HTML page
│   ├── styles.css        # CSS styling
│   ├── script.js         # JavaScript functionality
│   └── images/           # Image assets
│       └── demo.svg      # Demo image
├── deploy.sh             # rsync deployment script
├── setup.sh              # Initial setup script
├── test.sh               # Test suite
└── README.md             # This file
```

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- SSH client (usually pre-installed on macOS/Linux)

### 1. Setup the Environment

```bash
# Make scripts executable and run setup
chmod +x setup.sh deploy.sh test.sh
./setup.sh
```

This will:
- Start Docker containers (Nginx + SSH server)
- Generate SSH keys if needed
- Configure the environment

### 2. Deploy the Site

```bash
./deploy.sh
```

This will:
- Check server connectivity
- Sync files using rsync over SSH
- Deploy to the remote server

### 3. View Your Site

Open your browser and visit: http://localhost:8080

### 4. Run Tests

```bash
./test.sh
```

## Detailed Usage

### Deployment Script Commands

```bash
./deploy.sh           # Deploy the site (default)
./deploy.sh status    # Check deployment status
./deploy.sh setup-ssh # Setup SSH keys only
./deploy.sh help      # Show help
```

### Docker Management

```bash
# View container status
docker-compose ps

# View logs
docker-compose logs

# Stop containers
docker-compose down

# Restart containers
docker-compose restart
```

### SSH Access

You can SSH into the server container:

```bash
ssh -p 2222 deploy@localhost
# Password: password123
```

### Testing

Run specific test categories:

```bash
./test.sh all          # Run all tests
./test.sh files        # Test file existence
./test.sh docker       # Test Docker setup
./test.sh html         # Test HTML structure
./test.sh connectivity # Test server connectivity
```

## How It Works

### 1. Docker Setup

The `docker-compose.yml` defines two services:
- **nginx-server**: Serves static files on port 8080
- **ssh-server**: Provides SSH access on port 2222

### 2. Nginx Configuration

The `nginx.conf` file configures:
- Static file serving from `/usr/share/nginx/html`
- Proper MIME types and caching headers
- Security headers
- Error handling

### 3. Static Site

The site includes:
- Responsive HTML5 structure
- Modern CSS with flexbox and grid
- JavaScript for interactivity
- SVG graphics for images

### 4. rsync Deployment

The `deploy.sh` script:
- Establishes SSH connection
- Syncs local `site/` directory to remote server
- Uses rsync for efficient file transfer
- Provides status feedback and error handling

## Customization

### Modify the Website

Edit files in the `site/` directory:
- `index.html` - Page structure and content
- `styles.css` - Visual styling
- `script.js` - Interactive functionality
- `images/` - Add your own images

After making changes, run `./deploy.sh` to update the server.

### Change Server Configuration

Edit `nginx.conf` to modify:
- Server settings
- Cache policies
- Security headers
- URL routing

Restart containers after changes:
```bash
docker-compose restart
```

### Deployment Settings

Edit variables in `deploy.sh`:
- `REMOTE_HOST` - Server hostname/IP
- `REMOTE_PORT` - SSH port
- `REMOTE_USER` - SSH username
- `REMOTE_DIR` - Target directory

## Production Deployment

For production use:

1. **Use a real server** instead of Docker containers
2. **Configure proper SSH keys** with restricted permissions
3. **Set up a domain name** and SSL certificates
4. **Configure firewall rules** for security
5. **Use environment variables** for sensitive configuration
6. **Set up monitoring** and log rotation

### Example Production Deployment

```bash
# Edit deploy.sh for your production server
REMOTE_HOST="your-server.com"
REMOTE_PORT="22"
REMOTE_USER="deploy"
REMOTE_DIR="/var/www/html/"

# Deploy to production
./deploy.sh
```

## Troubleshooting

### Common Issues

**Containers won't start:**
```bash
# Check Docker status
docker --version
docker-compose --version

# View detailed logs
docker-compose logs -f
```

**SSH connection fails:**
```bash
# Check SSH key permissions
ls -la ~/.ssh/
chmod 600 ~/.ssh/id_rsa

# Test SSH connection manually
ssh -p 2222 -v deploy@localhost
```

**rsync fails:**
```bash
# Check connectivity
./deploy.sh status

# Test rsync manually
rsync -avz -e "ssh -p 2222" ./site/ deploy@localhost:/var/www/html/
```

**Site not loading:**
```bash
# Check if containers are running
docker-compose ps

# Check Nginx logs
docker-compose logs nginx-server

# Test HTTP connection
curl -I http://localhost:8080
```

### Getting Help

1. Run the test suite: `./test.sh`
2. Check container logs: `docker-compose logs`
3. Verify configuration: `docker-compose config`
4. Test connectivity: `./deploy.sh status`

## Security Notes

This setup is designed for development and learning. For production:

- Use strong SSH keys and disable password authentication
- Configure proper firewall rules
- Use HTTPS with SSL certificates
- Implement proper user permissions
- Regular security updates
- Monitor access logs

## License

This project is provided as-is for educational purposes. Feel free to modify and use as needed.