================================================================
  QUẢN GIA AI - SALES INTELLIGENCE
  Hướng dẫn sử dụng Demo
================================================================

CÁCH MỞ DEMO
────────────
1. Double-click vào file "run-demo.bat"
2. Chờ cửa sổ đen hiện lên và thông báo "Server đang chạy"
3. Trình duyệt sẽ tự động mở demo tại địa chỉ:
     http://localhost:8080/demo.html
4. Duyệt qua 17 màn hình bằng menu bên trái


CÁCH DỪNG DEMO
──────────────
• Nhấn Ctrl+C trong cửa sổ đen để dừng server, HOẶC
• Double-click vào file "stop-demo.bat"


CẤU TRÚC THƯ MỤC
────────────────
  run-demo.bat     ← Double-click để chạy demo
  stop-demo.bat    ← Dừng server
  README.txt       ← File này
  demo.html        ← Trang chính của demo
  clean/           ← Thư mục chứa 17 màn hình demo


YÊU CẦU HỆ THỐNG TỐI THIỂU
────────────────────────────
• Windows 10 hoặc Windows 11
• Trình duyệt: Chrome, Edge, Firefox (phiên bản mới nhất)
• Kết nối Internet: CẦN (để tải font và icon từ Google CDN)

Cài đặt thêm (không bắt buộc, nhưng giúp demo hoạt động tốt hơn):
  • Python 3.x → https://www.python.org/downloads/
    (Trong quá trình cài, tích vào "Add Python to PATH")
  • Hoặc Node.js → https://nodejs.org/

File .bat tự động phát hiện và dùng Python/Node nếu có sẵn.
Nếu không có, nó sẽ dùng PowerShell tích hợp sẵn của Windows.


XỬ LÝ LỖI THƯỜNG GẶP
──────────────────────
❌ Lỗi: "Trang trắng / không hiển thị gì"
   → Kiểm tra Internet (demo cần tải font từ Google)
   → Thử dùng Chrome hoặc Edge thay vì Internet Explorer

❌ Lỗi: "Cổng 8080 đang bận"
   → File .bat sẽ tự thử cổng 8081, 8082, 8083
   → Nếu tất cả đều bận, hãy chạy stop-demo.bat rồi thử lại

❌ Lỗi: "Windows đã chặn file .bat"
   → Click chuột phải vào run-demo.bat → Chọn "Run as administrator"
   → Hoặc: Click "More info" → "Run anyway" nếu Windows SmartScreen hiện

❌ Sidebar không ẩn / hiện 2 sidebar
   → Hãy mở demo bằng run-demo.bat (cần server HTTP, không mở thẳng file)

❌ Demo mở bằng Internet Explorer
   → Click chuột phải vào run-demo.bat → Chỉnh sửa (Edit)
   → Thay "start """ bằng "start chrome" hoặc "start msedge"


LIÊN HỆ HỖ TRỢ
───────────────
Nếu gặp vấn đề không giải quyết được theo hướng dẫn trên,
vui lòng chụp màn hình cửa sổ đen (cửa sổ cmd) và gửi cho
người phụ trách kỹ thuật.

================================================================
