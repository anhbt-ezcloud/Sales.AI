# 🧪 HƯỚNG DẪN TEST HỆ THỐNG PHÂN QUYỀN - Quản gia AI

## 📋 CHUẨN BỊ

1. Mở thư mục `f:/code/` trong VS Code (hoặc Explorer)
2. Dùng Live Server để chạy file HTML (cần extension Live Server trong VS Code)
   - Right-click vào file `.html` → Open with Live Server
   - Hoặc tải Go Live extension từ VS Code

---

## 🎬 KỊCH BẢN TEST 1: Admin Cấp Quyền → User Thấy File

### Bước 1: Mở Demo Admin
1. Right-click `demo-admin.html` → Open with Live Server
2. Xác nhận: ✅ Header hiển thị "ADMIN MODE" (góc phải), label account là "Admin"
3. Xác nhận: ✅ Sidebar có mục "Quản lý tài khoản" (footer)

### Bước 2: Admin Cấp Quyền File
1. Click "Quản lý tài khoản" ở footer sidebar
2. Bảng hiển thị 3 user: admin1, user1, user2
3. Click "Cấp quyền" cho user1
4. Dialog mở: hiển thị danh sách file Công khai (f001, f002, f003, f005, f007, f009, f011)
5. **Chọn checkbox**: `f001` (Báo cáo Quý 4 2024) ← File này sẽ được cấp quyền cho user1
6. Click "Lưu quyền truy cập"
7. Xác nhận: ✅ Toast "Cập nhật quyền thành công cho Nguyễn Văn A!" ✅ Bảng cập nhật: user1 thấy "+1 tài liệu"

### Bước 3: Chuyển Sang Demo User
1. Click link "Xem bản USER" ở góc phải header
   - **Hoặc** mở tab mới: `demo-user.html`
2. Xác nhận: ✅ Header hiển thị "USER MODE (Nguyễn Văn A)", label account là "User"
3. Xác nhận: ✅ Sidebar KHÔNG có "Quản lý tài khoản" (footer)

### Bước 4: Kiểm Tra User Thấy File Được Cấp
1. Click "Thư viện tài liệu" ở sidebar
2. Nếu có tabs: nhấp "Được cấp quyền"
3. **Kỳ vọng**: ✅ Thấy file `f001` (Báo cáo Quý 4 2024) trong danh sách
4. Click vào file f001
5. Xác nhận:
   - ✅ Mở drawer (side panel) với nội dung file
   - ✅ Có nút "← Quay lại Thư viện" ở header drawer
   - ✅ Không hiển thị message "Bạn không có quyền"

### Bước 5: Thử Xem File User Không Được Cấp
1. Quay lại Thư viện
2. Thử copy URL file f002 (chỉ cấp cho user2): `xem-tai-lieu.html?id=f002`
3. **Kỳ vọng**: ✅ Hiển thị message "🔒 Bạn không có quyền" + nút "Quay lại Thư viện"

---

## 🎬 KỊCH BẢN TEST 2: User Khác KHÔNG Thấy File

### Bước 1: Admin Cấp Quyền Cho User2 Only
1. Về lại `demo-admin.html`
2. Vào "Quản lý tài khoản"
3. Cấp quyền cho user2: chọn file `f003` (Kế hoạch Marketing Q4)
4. Lưu

### Bước 2: Kiểm Tra User1 Không Thấy
1. Về `demo-user.html` (user1)
2. Vào "Thư viện tài liệu" → Tab "Được cấp quyền"
3. **Kỳ vọng**: ✅ KHÔNG thấy file f003
4. Xác nhận: ✅ User1 chỉ thấy file f001, không thấy file f003

### Bước 3: Kiểm Tra User2 Thấy
1. Mở `demo-user.html` và **chỉnh URL** tay:
   - Hoặc tạo tab mới, copy URL `demo-user.html`
   - Rồi trong console chạy: `setCurrentUser('user2')`
2. Hoặc tạo file `demo-user2.html` tương tự (copy `demo-user.html`, đổi `setCurrentUser('user1')` → `setCurrentUser('user2')`)
3. Vào "Thư viện tài liệu" → "Được cấp quyền"
4. **Kỳ vọng**: ✅ Thấy file f003

---

## 🎬 KỊCH BẢN TEST 3: File Cá Nhân Của User Không Bị Admin Thấy

### Bước 1: Mock Upload File Cá Nhân (User1)
1. Ở `demo-user.html` (user1)
2. Click "Upload tài liệu" ở sidebar
3. Mock upload 1 file (drag-drop hoặc chọn)
4. Chọn folder "Cá nhân"
5. Click "Upload & Chat ngay"
6. (File này sẽ có ownerId = user1, docType = private)

**Note**: Hiện tại là mock, dữ liệu chỉ lưu trong memory, không persist. Để test, bạn cần:
- **Cách 1 (nhanh)**: Sửa mock data trong `js/permissions.js`
  - Thêm file mới với ownerId = user1: `{ id: 'f_user1', name: 'File Cá Nhân User1.pdf', ownerId: 'user1', ... }`
- **Cách 2 (mock upload)**: Sửa JS trong `upload-tai-lieu.html` để thêm file vào FILES khi submit

### Bước 2: Kiểm Tra Admin Không Thấy
1. Về `demo-admin.html` (admin1)
2. Vào "Thư viện tài liệu"
3. **Kỳ vọng**: ✅ Admin KHÔNG thấy file cá nhân của user1
4. Nếu admin cố `xem-tai-lieu.html?id=f_user1` → ✅ Message "Bạn không có quyền"

---

## 📊 BẢNG KIỂM DANH SÁCH

### Account & Role
- [ ] demo.html: Dropdown account hoạt động, chuyển account re-render UI
- [ ] demo-admin.html: Hard-code admin, button "Xem USER" link đúng
- [ ] demo-user.html: Hard-code user1, button "Xem ADMIN" link đúng

### Sidebar
- [ ] Menu "Quản lý tài khoản": chỉ hiển thị admin
- [ ] Counter: "Màn hình 1 / 13" (không phải 15)
- [ ] "Tùy chọn nhanh": đổi từ "Context Menu"

### Permission System
- [ ] Admin cấp quyền → User thấy file ✅
- [ ] User khác KHÔNG thấy file ✅
- [ ] File cá nhân: chỉ owner + admin xem được ✅
- [ ] xem-tai-lieu.html: kiểm tra quyền + nút quay lại ✅

### UI Elements
- [ ] xem-tai-lieu.html: nút back "← Quay lại Thư viện"
- [ ] xem-tai-lieu.html: message "🔒 Bạn không có quyền"
- [ ] quan-ly-tai-khoan.html: bảng user + dialog cấp quyền

---

## 🛠️ TROUBLESHOOTING

### Lỗi 1: "permissions.js not found"
- Kiểm tra đường dẫn import trong file HTML
- Demo files (demo.html, demo-admin.html): `<script src="js/permissions.js"></script>`
- Sub-files (thu-vien-tai-lieu.html): `<script src="../js/permissions.js"></script>`
- Hoặc `<script src="js/permissions.js"></script>` tuỳ vị trí

### Lỗi 2: Dropdown account không hiện
- Live Server có hỗ trợ `http://localhost:xxxx` (không file://)
- Kiểm tra console (F12) cho JS errors

### Lỗi 3: Permission dialog không cập nhật
- Mock data lưu trong memory, không persist khi reload
- Để test lại: reload page và cấp quyền lại

---

## 📝 NOTES

1. **Mock vs Real**: Hiện tại dùng mock data trong `js/permissions.js`. Dữ liệu không persist qua reload.
2. **Persist (optional)**: Thêm `localStorage` để lưu FILE_PERMISSIONS
3. **Backend**: Khi có backend API, thay `FILE_PERMISSIONS` object bằng API calls
4. **File IDs**: Mock dùng số (1-12). Có thể sửa thành string (f001, f002, ...) để align với code

---

**Chúc bạn test thành công!** 🎉
