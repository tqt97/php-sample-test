<?php
// Logic xử lý form
$postData = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Làm sạch dữ liệu (Sanitize data)
    $fullname = filter_input(INPUT_POST, 'fullname', FILTER_SANITIZE_SPECIAL_CHARS);
    $email = filter_input(INPUT_POST, 'email', FILTER_SANITIZE_EMAIL);

    $postData = [
        'fullname' => $fullname,
        'email' => $email,
        'original_post' => $_POST
    ];
}
