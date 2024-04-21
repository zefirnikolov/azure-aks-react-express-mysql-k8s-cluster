FROM nginxinc/nginx-unprivileged:1.25-alpine


# Switch to root to perform privileged operations
USER root

# Install OpenSSL for certificate generation
RUN apk --update add openssl \
    && rm -rf /var/cache/apk/*

# Create a directory for the certs
RUN mkdir -p /etc/nginx/certs

# Generate a self-signed SSL certificate and private key
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/tls.key \
    -out /etc/nginx/certs/tls.crt \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"

# Ensure that the Nginx user can read the certificate and key
RUN chown -R nginx:nginx /etc/nginx/certs && \
    chmod 644 /etc/nginx/certs/tls.crt && \
    chmod 600 /etc/nginx/certs/tls.key

# Switch back to nginx user before starting Nginx
USER nginx

COPY ./build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf


CMD ["nginx", "-g", "daemon off;"]
