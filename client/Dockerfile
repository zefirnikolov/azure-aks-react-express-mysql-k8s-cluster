FROM nginxinc/nginx-unprivileged

COPY ./build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
# COPY ./certs /etc/nginx/certs

EXPOSE 8080
# EXPOSE 8443

CMD ["nginx", "-g", "daemon off;"]
