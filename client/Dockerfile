FROM nginxinc/nginx-unprivileged:1.25-alpine


USER root

RUN mkdir -p /etc/nginx/certs
COPY ./dummy.crt  /etc/nginx/certs/tls.crt
COPY ./duimmy.key  /etc/nginx/certs/tls.key

RUN chown -R nginx:nginx /etc/nginx/certs && \
    chmod 644 /etc/nginx/certs/tls.crt && \
    chmod 600 /etc/nginx/certs/tls.key

USER nginx

COPY ./build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf


CMD ["nginx", "-g", "daemon off;"]
