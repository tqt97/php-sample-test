FROM php:7.0-fpm

ARG PHP_EXT_SET=full

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions pdo_mysql mysqli zip intl opcache bcmath exif mcrypt && \
    if [ "$PHP_EXT_SET" = "full" ]; then \
        install-php-extensions gd redis-4.3.0 soap xsl; \
    fi

COPY --from=composer:1 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html/
USER www-data

EXPOSE 9000
CMD ["php-fpm"]
