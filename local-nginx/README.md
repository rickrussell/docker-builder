# Local Nginx
This image is for running an nginx proxy locally to resolve hostnames and add ssl

## Usage
When running this image, you'll need to mount a directory to /etc/nginx/ssl that contains noneck_test.key and noneck_test.crt.

For www to work, you'll need to mount the html to /etc/nginx/website-dist
