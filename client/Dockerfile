FROM nginxinc/nginx-unprivileged:1.25-alpine


RUN mkdir -p /etc/nginx/certs \
    && touch /etc/nginx/certs/tls.crt \
    && touch /etc/nginx/certs/tls.key

COPY ./build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf


CMD ["nginx", "-g", "daemon off;"]
