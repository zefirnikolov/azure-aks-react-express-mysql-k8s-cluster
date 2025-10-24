FROM nginxinc/nginx-unprivileged:1.25-alpine


USER root

RUN mkdir -p /etc/nginx/certs
COPY ./dummy.crt  /etc/nginx/certs/tls.crt
COPY ./dummy.key  /etc/nginx/certs/tls.key
COPY ./bootstrap.js /usr/share/nginx/html/bootstrap.js

RUN chown -R nginx:nginx /etc/nginx/certs && \
    chmod 644 /etc/nginx/certs/tls.crt && \
    chmod 600 /etc/nginx/certs/tls.key

RUN chown -R nginx:nginx /usr/share/nginx/html/bootstrap.js && \
    chmod 644 /usr/share/nginx/html/bootstrap.js

USER nginx

COPY ./build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080
EXPOSE 8443

CMD ["nginx", "-g", "daemon off;"]
