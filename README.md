# 🚀 Ultimate PHP Docker Powerhouse

Hệ thống Docker chuyên nghiệp hỗ trợ đa phiên bản PHP, SSL tự động và tối ưu cho mọi Framework PHP (Laravel, FuelPHP, Symfony, WordPress, v.v.).

## 🌟 Tính năng nổi bật

- **Đa phiên bản PHP**: Chuyển đổi linh hoạt giữa PHP 7.0, 7.4, 8.1, 8.2, 8.3.
- **Hỗ trợ Framework**: Tích hợp sẵn bộ cài Laravel và FuelPHP tương thích với từng phiên bản PHP.
- **Full Extensions**: Đã cài đặt sẵn bộ extension "khủng" (gd, intl, redis, imagick, pdo_mysql, zip, v.v.).
- **SSL Ready**: Hỗ trợ giao thức HTTPS với cấu hình sẵn trong Nginx.
- **Custom Domain**: Chạy dự án với tên miền riêng (ví dụ: `myapp.test`) thay vì `localhost`.

## 🏗️ Cấu trúc đa phiên bản

```text
docker/php/
├── 7.0/Dockerfile
├── 7.4/Dockerfile
├── 8.1/Dockerfile
├── 8.2/Dockerfile (Default)
└── 8.3/Dockerfile
```

## 🚀 Hướng dẫn thiết lập

### 1. Khởi tạo nhanh

```bash
chmod +x setup.sh generate-ssl.sh
./setup.sh
```

Trong quá trình chạy `setup.sh`, bạn sẽ được hỏi:

- Chọn phiên bản PHP.
- Có muốn cài đặt Framework (Laravel/FuelPHP) hay không. Nếu không, hệ thống sẽ sử dụng code PHP thuần hiện tại.

### 2. Cấu hình SSL (HTTPS)

Để chạy HTTPS mà không bị cảnh báo lỗi trình duyệt (trong môi trường dev), hãy tạo chứng chỉ tự ký:

```bash
./generate-ssl.sh
```

### 3. Cấu hình Tên miền ảo (Custom Domain)

Để chạy dự án với tên miền `myapp.test`:

1. Mở file `.env` và sửa `APP_DOMAIN=myapp.test`.
2. Thêm dòng sau vào file `hosts` của máy tính bạn:
   - **Linux/macOS**: `/etc/hosts`
   - **Windows**: `C:\Windows\System32\drivers\etc\hosts`

   ```text
   127.0.0.1  myapp.test
   ```

## 🔄 Cách chuyển đổi phiên bản PHP

1. Mở file `.env`.
2. Thay đổi giá trị `PHP_VERSION` (ví dụ: `PHP_VERSION=7.4`).
3. Khởi động lại và build lại:

   ```bash
   make build
   make up
   ```

## ⌨️ Các lệnh quản lý (Makefile)

| Lệnh | Mô tả |
| :--- | :--- |
| `make up` | Khởi chạy hệ thống |
| `make build` | Xây dựng lại Image (dùng khi đổi bản PHP hoặc thêm extension) |
| `make shell` | Vào Terminal của container PHP |
| `make logs` | Xem nhật ký hoạt động |
| `make db-shell` | Truy cập vào terminal của container MariaDB để chạy lệnh SQL trực tiếp
|  `make migrate` | Chạy tất cả các file .sql trong thư mục database/migrations/ theo thứ tự tên file.

## 🗄️ Quản lý Database

### Tạo bảng SQL (Migrations)

Hệ thống hỗ trợ chạy các file SQL để tạo hoặc cập nhật cấu trúc bảng.

 1. **Tạo thư mục:** Tạo thư mục `database/migrations/` trong thư mục gốc của dự án.
 2. **Tạo file SQL:** Tạo các file `.sql` bên trong thư mục này. Đặt tên file theo thứ tự để đảm bảo chúng được chạy đúng thứ tự (ví dụ:
      `001_create_users_table.sql`, `002_create_products_table.sql`).
     - File `001_create_users_table.sql` đã được tạo sẵn để bạn bắt đầu.