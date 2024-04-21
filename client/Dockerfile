FROM nginxinc/nginx-unprivileged:1.25-alpine


RUN mkdir -p /etc/nginx/certs \
    && echo "-----BEGIN CERTIFICATE-----" > /etc/nginx/certs/tls.crt \
    && echo "Dummy certificate content" >> /etc/nginx/certs/tls.crt \
    && echo "-----END CERTIFICATE-----" >> /etc/nginx/certs/tls.crt \
    && echo "-----BEGIN PRIVATE KEY-----" > /etc/nginx/certs/tls.key \
    && echo "Dummy private key content" >> /etc/nginx/certs/tls.key \
    && echo "-----END PRIVATE KEY-----" >> /etc/nginx/certs/tls.key

COPY ./build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf


CMD ["nginx", "-g", "daemon off;"]
