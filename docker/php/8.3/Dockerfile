FROM php:8.3-fpm

ARG PHP_EXT_SET=full

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions pdo_mysql mysqli zip intl opcache bcmath exif && \
    if [ "$PHP_EXT_SET" = "full" ]; then \
        install-php-extensions gd redis imagick soap sodium sysvmsg sysvsem sysvshm xsl; \
    fi

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html/
USER www-data

EXPOSE 9000
CMD ["php-fpm"]
