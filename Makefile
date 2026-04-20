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

restart:
	docker compose down && docker compose up -d

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

composer:
	docker compose exec php composer install

migrate: ## Chạy các SQL migrations
	./scripts/migrate.sh

seed:
	docker compose exec db sh -c 'mysql -u$$MYSQL_USER -p$$MYSQL_PASSWORD $$MYSQL_DATABASE < /var/www/html/database/seeders/001_seed_users.sql'

migration:
	@if [ -z "$(name)" ]; then \
		echo "❌ Usage: make migration name=create_users_table"; \
		exit 1; \
	fi; \
	filename=$$(date +%Y%m%d%H%M%S)_$(name).sql; \
	mkdir -p database/migrations; \
	cat <<EOF > database/migrations/$$filename
-- Migration: $(name)
-- Created at: $$(date)

-- UP
-- Write your SQL here

-- DOWN
-- Rollback SQL here
EOF
	echo "✅ Created migration: $$filename"