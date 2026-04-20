# 🛡️ Giải thích cơ chế "Double-check State" (Chống F12)

Cơ chế này sử dụng **2 biến cờ (flags)** để theo dõi hành vi của người dùng, đảm bảo họ đi đúng trình tự logic thay vì chỉ kiểm tra hành động click cuối cùng.

## 1. Vai trò của 2 biến cờ

* `isConfirmed` (Cờ trạng thái Server): Mặc định là `false`. Chỉ khi cờ này là `true`, dữ liệu mới được phép bay lên Server.
* `isReadyToConfirm` (Cờ trạng thái UI): Mặc định là `false`. Biến này lưu vết xem người dùng **đã thực sự nhấn nút Submit Form** hay chưa.

---

## 2. Mô phỏng 2 kịch bản (Luồng đi)

### Kịch bản 1: Người dùng hợp lệ (Đi đúng luồng)

1. **Điền form & nhấn Submit:** Form phát ra sự kiện `submit`.
2. **Kiểm tra cờ 1:** Do `isConfirmed` đang là `false`, code gọi `e.preventDefault()` để chặn gửi đi.
3. **Bật cờ 2:** Code set `isReadyToConfirm = true` (Ghi nhận: "À, người này đã đi qua bước form"). Sau đó hiện Modal.
4. **Nhấn Đồng ý:** Nút này kiểm tra xem `isReadyToConfirm` có phải `true` không? -> **CÓ**.
5. **Gửi dữ liệu:** Code set `isConfirmed = true` và gọi `$('#testForm').submit()`. Lúc này dữ liệu được bay thẳng lên Server.

### Kịch bản 2: Kẻ gian dùng F12 (Vượt rào)

1. Kẻ gian không điền form, không nhấn Submit. Họ bật F12 (Inspect Element).
2. Họ tìm đến thẻ `<div id="confirmModal"...>` và xóa class `hidden`. Popup hiện lên màn hình!
3. **Nhấn Đồng ý:** Nút này kiểm tra xem `isReadyToConfirm` có phải `true` không? -> **KHÔNG** (vì họ chưa từng nhấn nút Submit của form, nên đoạn code bật cờ chưa bao giờ được chạy).
4. **Bị chặn lại:** Code rơi vào nhánh `else`, văng ra cảnh báo (alert) và ngay lập tức đóng Modal lại. Kẻ gian thất bại.

---

## 3. Vì sao nó an toàn ở cấp độ UI?

Nó thay đổi tư duy từ **"Nút Đồng ý là người ra quyết định"** thành **"Nút Đồng ý chỉ là người kiểm tra"**.

Nút Đồng ý không có quyền tự submit form, nó chỉ được phép gọi lệnh submit nếu và chỉ nếu **sự kiện submit đã từng xảy ra trước đó**. Điều này vô hiệu hóa hoàn toàn việc thao túng giao diện bằng CSS/HTML.

> **⚠️ Lưu ý bảo mật:**
> Đây là phương pháp phòng thủ vững chắc ở phía Client (Trình duyệt). Tuy nhiên, hacker giỏi có thể bỏ qua hoàn toàn giao diện web của bạn và dùng các công cụ như Postman hoặc cURL để gửi thẳng data dạng POST lên file `index.php`. Do đó, dữ liệu luôn cần được làm sạch (sanitize) ở phía PHP.

Điểm cốt lõi của phương pháp này nằm ở việc chúng ta không tin tưởng vào trạng thái hiển thị (Modal đang ẩn hay hiện), mà chúng ta tin tưởng vào lịch sử sự kiện (Người dùng đã từng click vào nút submit của form hay chưa).

Nhờ biến isReadyToConfirm, dù ai đó có dùng F12 hiển thị Modal lên hay viết lệnh JavaScript trong console để ép click vào nút "Đồng ý", họ vẫn sẽ bị chặn lại vì lịch sử hành động của họ là một con số 0.
