FROM alpine:3.20
RUN apk update && apk upgrade && apk add \
    openssl\
    nginx\
    curl\
    vim\
    sudo
RUN mkdir -p /etc/nginx/ssl /var/www/html /run/nginx
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=75/L=Paris/O=42/CN=localhost"
RUN rm -f /etc/nginx/nginx.conf
COPY ./config/nginx.conf /etc/nginx/nginx.conf
RUN echo "<h1>Welcome to Inception 🚀</h1>" > /var/www/html/index.html
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
