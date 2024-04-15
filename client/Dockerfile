FROM nginxinc/nginx-unprivileged:1.25-alpine


COPY ./build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf


CMD ["nginx", "-g", "daemon off;"]
