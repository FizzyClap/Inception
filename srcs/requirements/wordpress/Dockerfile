FROM alpine:3.20
RUN apk update && apk upgrade && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-opcache \
    php82-curl \
    php82-gd \
    php82-mbstring \
    php82-xml \
    php82-zip \
    php82-session \
    php82-tokenizer \
	php82-phar \
	curl\
	mysql-client

# Création du lien symbolique pour PHP
RUN ln -s /usr/bin/php82 /usr/bin/php

WORKDIR /var/www/html

RUN adduser -S www-data -G www-data


RUN curl https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz --strip-components=1 \
    && rm latest.tar.gz \
    && chown -R www-data:www-data /var/www/html

# Installation de WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
chmod +x wp-cli.phar && \
mv wp-cli.phar /usr/local/bin/wp
RUN mkdir -p /run/php
COPY ./tools/script.sh /setup_wordpress.sh
RUN chmod +x /setup_wordpress.sh

COPY config/wordpress.conf /etc/php82/php-fpm.d/www.conf

EXPOSE 9000
CMD ["sh", "/setup_wordpress.sh"]
