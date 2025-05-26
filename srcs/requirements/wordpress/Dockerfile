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
    curl \
    mysql-client

# Symlink php82 to php (optional convenience)
RUN ln -s /usr/bin/php82 /usr/bin/php

WORKDIR /var/www/html

# Add www-data user/group for permissions
RUN adduser -S www-data -G www-data

# Download and extract WordPress
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz --strip-components=1 && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www/html

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create run directory for php-fpm socket/pid
RUN mkdir -p /run/php

# Copy PHP-FPM config (make sure wordpress.conf is correct)
COPY config/wordpress.conf /etc/php82/php-fpm.d/www.conf

# Copy your setup script
COPY ./tools/script.sh /setup_wordpress.sh
RUN chmod +x /setup_wordpress.sh

EXPOSE 9000

# Use shell form so env vars are available and script is PID 1
CMD ["sh", "/setup_wordpress.sh"]
