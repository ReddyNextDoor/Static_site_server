The goal of this project is to understand the how to set up a web server using a static site served using Nginx specifically using 'rsync' to deploy your changes to the server.

## Requirements
####Here are the requirements for this project:

Register and setup a remote linux server on any provider e.g. a simple droplet on DigitalOcean which gives you $200 in free credits with the link. Alternatively, use AWS or any other provider.

Make sure that you can connect to your server using SSH.

Install and configure nginx to serve a static site.

Create a simple webpage with basic HTML, CSS and image files.

Use rsync to update a remote server with a local static site.

If you have a domain name, point it to your server and serve your static site from there. Alternatively, set up your nginx server to serve the static site from the server's IP address.

You can write a script deploy.sh which when you run will use rsync to sync your static site to the server.
