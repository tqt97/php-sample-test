$(document).ready(function () {
	// 1. Cờ kiểm tra form đã sẵn sàng để submit thật lên server chưa
	let isConfirmed = false;

	// 2. Cờ kiểm tra user đã đi qua bước "Click nút submit form" chưa
	let isReadyToConfirm = false;

	// Khi form phát ra sự kiện submit
	$('#testForm').on('submit', function (e) {
		if (!isConfirmed) {
			e.preventDefault(); // Chặn hành động submit mặc định
			isReadyToConfirm = true; // Xác nhận user đã đi đúng luồng (đã nhập form)
			$('#confirmModal').removeClass('hidden'); // Hiện popup
		}
		// Nếu isConfirmed là true, code bỏ qua block if này và form gửi đi bình thường
	});

	// Khi ấn nút Hủy trong popup
	$('#cancelBtn').on('click', function () {
		$('#confirmModal').addClass('hidden'); // Ẩn popup
		isReadyToConfirm = false; // Reset lại trạng thái
	});

	// Khi ấn nút Đồng ý trong popup
	$('#confirmBtn').on('click', function () {
		// KIỂM TRA LỚP BẢO VỆ: Chỉ cho phép click nếu đã qua bước submit form
		if (isReadyToConfirm === true) {
			isConfirmed = true;      // Bật cờ cho phép submit thật
			$('#testForm').submit(); // Gọi lại sự kiện submit form (lúc này sẽ lọt qua được hàm if ở trên)
		} else {
			// Xử lý kẻ gian dùng F12 xóa class hidden
			console.warn("Phát hiện thao tác không hợp lệ!");
			alert("Vui lòng điền form và nhấn Gửi yêu cầu trước khi xác nhận.");
			$('#confirmModal').addClass('hidden'); // Cưỡng ép đóng popup lại
		}
	});
});