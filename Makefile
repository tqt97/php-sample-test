APP_NAME ?= php-sample # Define APP_NAME if not already defined

# SQL Migrations
# Sử dụng biến từ .env để kết nối DB
DB_CONTAIN_NAME=$(grep APP_NAME .env | cut -d '=' -f2)-db
DB_USER=$(grep DB_USERNAME .env | cut -d '=' -f2)
DB_PASS=$(grep DB_PASSWORD .env | cut -d '=' -f2)
DB_NAME=$(grep DB_DATABASE .env | cut -d '=' -f2)

.PHONY: help up down build ps logs shell migrate db-shell

help:
	@echo "Các lệnh hỗ trợ:"
	@echo "  make up          Khởi chạy các container"
	@echo "  make down        Dừng và xóa các container"
	@echo "  make build       Xây dựng lại các image"
	@echo "  make ps          Kiểm tra trạng thái các container"
	@echo "  make logs        Xem log của các container"
	@echo "  make shell       Truy cập vào shell của container PHP"
	@echo "  make db-shell    Truy cập vào shell của MariaDB"
	@echo "  make migrate    Chạy các SQL migrations"

up:
	docker-compose up -d

down:
	docker-compose down

build:
	docker-compose build

ps:
	docker-compose ps

logs:
	docker-compose logs -f

shell:
	docker exec -it $(APP_NAME)-app bash

db-shell:
	docker exec -it $(DB_CONTAIN_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME)

migrate: ## Chạy các SQL migrations
	@echo "🚀 Đang chạy SQL migrations..."
	@mkdir -p database/migrations/ # Đảm bảo thư mục tồn tại
	# Create migration file if it doesn't exist, executed as a single shell command
	@sh -c '[ ! -f database/migrations/001_create_users_table.sql ] && (echo "CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL UNIQUE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);" > database/migrations/001_create_users_table.sql && echo "✅ Đã tạo file migration mẫu: database/migrations/001_create_users_table.sql") || true'
	@echo "Running migrations from database/migrations/..."
	# Apply all SQL migrations found
	@find database/migrations/ -name "*.sql" -type f -exec sh -c 'echo "--- Applying {} ---"; docker exec -i $(DB_CONTAIN_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < {}' \;
	@echo "✅ Migrations applied successfully!"
