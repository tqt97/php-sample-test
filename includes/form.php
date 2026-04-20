<div class="bg-white p-8 rounded-lg shadow-md w-full max-w-3xl">
    <h2 class="text-2xl font-bold mb-6 text-gray-800">Nhập thông tin</h2>

    <?php if ($postData): ?>
        <div class="mb-4 p-4 bg-green-100 text-green-700 rounded-md">
            <strong>Đã nhận POST data:</strong>
            <pre class="text-sm mt-2"><?php print_r($postData); ?></pre>
        </div>
    <?php endif; ?>

    <form id="testForm" method="POST" action="">
        <div class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="fullname">Họ và tên</label>
            <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700" id="fullname"
                name="fullname" type="text" required>
        </div>
        <div class="mb-6">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="email">Email</label>
            <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700" id="email"
                name="email" type="email" required>
        </div>

        <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded w-full">
            Gửi thông tin
        </button>
    </form>
</div>