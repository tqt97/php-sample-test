FROM php:8.2-fpm

# Biến để quyết định bộ extension nào sẽ được cài (lite hoặc full)
ARG PHP_EXT_SET=full

# Cài đặt công cụ cài extension PHP tối ưu
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    # Cài đặt các extension cơ bản (luôn cần thiết)
    install-php-extensions pdo_mysql mysqli zip intl opcache bcmath exif && \
    # Nếu là bộ "full", cài thêm các extension nặng cho Framework
    if [ "$PHP_EXT_SET" = "full" ]; then \
        install-php-extensions gd redis imagick soap sockets sodium sysvmsg sysvsem sysvshm xsl; \
    fi

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html/
USER www-data

EXPOSE 9000
CMD ["php-fpm"]
