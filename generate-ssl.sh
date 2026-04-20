#!/bin/bash
mkdir -p docker/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout docker/nginx/ssl/server.key \
    -out docker/nginx/ssl/server.crt \
    -subj "/C=VN/ST=Hanoi/L=Hanoi/O=IT/CN=myapp.test"
echo "✅ Chứng chỉ SSL đã được tạo tại docker/nginx/ssl/"
