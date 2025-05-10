FROM alpine:3.20
RUN apk update && apk upgrade && apk add \
 php\
 php-fpm\
 php-mysqli\
 php-curl\
 php-json\
 php-mbstring\
 php-session\
 php-dom\
 php-openssl\
 php-zlib\
 php-gd\
 curl\
 vim\
 sudo
WORKDIR /var/www/wordpress
RUN curl -O https://wordpress.org/latest.tar.gz && \
 tar -xzf latest.tar.gz --strip-components=1 && \
 rm latest.tar.gz
RUN mkdir -p /run/php
COPY ./tools/script.sh /setup_wordpress.sh
RUN chmod +x /setup_wordpress.sh
EXPOSE 9000
CMD ["sh", "/setup_wordpress.sh"]
