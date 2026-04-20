<?php require_once 'includes/process.php'; ?>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Form + Confirm Popup</title>

    <!-- CSS Assets -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="./assets/style.css">
</head>

<body class="bg-gray-100 min-h-screen flex items-center justify-center p-4">

    <!-- Form Section -->
    <?php include 'includes/form.php'; ?>

    <!-- Modal Section -->
    <?php include 'includes/modal.php'; ?>

    <!-- JS Assets -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="./assets/app.js"></script>

</body>

</html>