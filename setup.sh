#!/bin/bash

# --- Màu sắc ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 Chào mừng bạn đến với PHP Docker Powerhouse Setup!${NC}"

# 1. Khởi tạo .env
if [ ! -f .env ]; then
    cp .env.example .env
fi

# 2. Chọn phiên bản PHP
echo -e "${YELLOW}👉 Chọn phiên bản PHP (7.0, 7.4, 8.1, 8.2, 8.3) [Mặc định 8.2]:${NC}"
read php_ver
php_ver=${php_ver:-8.2}

# Kiểm tra file Dockerfile tồn tại
if [ ! -d "docker/php/$php_ver" ]; then
    echo -e "${YELLOW}⚠️ Phiên bản $php_ver chưa được hỗ trợ hoàn toàn, sử dụng mặc định 8.2.${NC}"
    php_ver="8.2"
fi

# Cập nhật .env
if grep -q "PHP_VERSION=" .env; then
    sed -i "s/PHP_VERSION=.*/PHP_VERSION=$php_ver/" .env
else
    echo "PHP_VERSION=$php_ver" >> .env
fi

# 3. Hỏi cài đặt Framework
echo -e "${YELLOW}❓ Bạn có muốn cài đặt Framework không? (y/n) [n]:${NC}"
read install_fw

APP_ROOT=""
PHP_EXT_SET="lite"

if [[ "$install_fw" == "y" || "$install_fw" == "Y" ]]; then
    PHP_EXT_SET="full"
    echo -e "${YELLOW}📦 Chọn Framework:${NC}"
    echo "1) Laravel"
    echo "2) FuelPHP"
    read fw_choice

    case $fw_choice in
        1)
            echo -e "${BLUE}📥 Đang chuẩn bị cài đặt Laravel...${NC}"
            # Chọn phiên bản Laravel dựa trên PHP
            LARAVEL_VER=""
            if [[ "$php_ver" == "7.0" ]]; then
                LARAVEL_VER="5.5.*"
            elif [[ "$php_ver" == "7.4" ]]; then
                LARAVEL_VER="8.*"
            fi
            
            if [ -n "$LARAVEL_VER" ]; then
                docker run --rm -it -v $(pwd):/app composer create-project laravel/laravel:$LARAVEL_VER tmp_laravel --prefer-dist
            else
                docker run --rm -it -v $(pwd):/app composer create-project laravel/laravel tmp_laravel --prefer-dist
            fi
            
            mv tmp_laravel/* tmp_laravel/.* . 2>/dev/null
            rm -rf tmp_laravel
            APP_ROOT="/public"
            ;;
        2)
            echo -e "${BLUE}📥 Đang chuẩn bị cài đặt FuelPHP...${NC}"
            docker run --rm -it -v $(pwd):/app composer create-project fuel/fuel tmp_fuel --prefer-dist
            mv tmp_fuel/* tmp_fuel/.* . 2>/dev/null
            rm -rf tmp_fuel
            APP_ROOT="/public"
            ;;
        *)
            echo "❌ Lựa chọn không hợp lệ, bỏ qua cài đặt framework."
            PHP_EXT_SET="lite"
            ;;
    esac
fi

# Cập nhật PHP_EXT_SET vào .env
if grep -q "PHP_EXT_SET=" .env; then
    sed -i "s/PHP_EXT_SET=.*/PHP_EXT_SET=$PHP_EXT_SET/" .env
else
    echo "PHP_EXT_SET=$PHP_EXT_SET" >> .env
fi

# Cập nhật APP_ROOT vào .env để Nginx biết đường dẫn
if grep -q "APP_ROOT=" .env; then
    sed -i "s|APP_ROOT=.*|APP_ROOT=$APP_ROOT|" .env
else
    echo "APP_ROOT=$APP_ROOT" >> .env
fi

# 4. Khởi chạy Docker
echo -e "${BLUE}🛠️ Đang khởi chạy hệ thống Docker (PHP $php_ver)...${NC}"
docker-compose down -v --remove-orphans 2>/dev/null || true
docker-compose up -d --build

echo -e "${GREEN}--- ✨ HOÀN THÀNH ---${NC}"
echo -e "🌐 URL: http://localhost:8080"
echo -e "💡 Dùng 'make help' để xem các lệnh quản lý."
