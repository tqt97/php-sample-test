FROM php:8.2-fpm

# Cài đặt các thư viện hệ thống cần thiết
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libzip-dev \
    libicu-dev

# Xóa cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Cài đặt PHP extensions
RUN docker-php-ext-install pdo_mysql mysqli mbstring exif pcntl bcmath gd zip intl

# Cài đặt Composer (nếu cần mở rộng sau này)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Thiết lập thư mục làm việc
WORKDIR /var/www/html

# Cấp quyền
RUN chown -R www-data:www-data /var/www/html/

USER www-data

EXPOSE 9000
CMD ["php-fpm"]
