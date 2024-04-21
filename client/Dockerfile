FROM nginxinc/nginx-unprivileged:1.25-alpine


# Create dummy SSL certificates to prevent Nginx from failing to start
# Install OpenSSL
RUN apt-get update && \
    apt-get install -y openssl

# Create a directory for the certs
RUN mkdir -p /etc/nginx/certs

# Generate a self-signed SSL certificate and private key
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/tls.key \
    -out /etc/nginx/certs/tls.crt \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

# Clean up APT when done.
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf


CMD ["nginx", "-g", "daemon off;"]
