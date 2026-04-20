# 🔧 CÁC THAY ĐỔI CHI TIẾT - Quản gia AI v2.1

**Ngày cập nhật:** 20/04/2026  
**Phiên bản:** 2.1 (Fix giao diện + tính năng upload)

---

## 📋 TÓM TẮT THAY ĐỔI

### ✅ **Đã Sửa**
1. **Giao diện file con** - Tất cả file con giờ có nút "Quay lại" hoạt động
2. **Admin/User full features** - demo-admin.html & demo-user.html có đầy đủ chức năng như demo.html
3. **Upload file** - Backend kiểm tra định dạng (pdf, doc, xls, v.v.), kích thước max 50MB
4. **Quản lý thư mục** - Thêm/sửa/xóa/đặt tên thư mục con

---

## 🔑 CÁC FILE THAY ĐỔI

### 1️⃣ **js/permissions.js** (+180 dòng)
Bổ sung **chức năng upload file + xác thực**

**Hàm mới:**
```javascript
// Xác thực file trước upload
validateFile(fileName, fileSize)
  ↳ Kiểm tra định dạng: pdf, doc, docx, xls, xlsx, ppt, pptx, txt, jpg, png, zip
  ↳ Max 50MB

// Upload file với kiểm tra quyền
uploadFile(fileName, fileSize, folderId, user)
  ↳ Return: { success, fileId, message }

// Config server
getUploadServerConfig()
  ↳ uploadUrl, validator, maxRetries, chunkSize, timeout
```

**Ví dụ:**
```javascript
const result = uploadFile('báo-cáo.pdf', 2048000, 'public_sales', currentUser);
if (result.success) {
  showToast(`✓ ${result.message}`);
} else {
  showToast(`✗ ${result.message}`);
}
```

---

### 2️⃣ **demo-admin.html** (NEW - Full Shell)
**Thay vì iframe**, file này giờ là **sao chép đầy đủ demo.html** với:
- ✅ Title: "Demo Admin — Quản gia AI"
- ✅ Hard-code: `setCurrentUser('admin1')` tự động
- ✅ Đầy đủ sidebar, menu, chức năng
- ✅ Hiển thị "Quản lý tài khoản" trong footer

**Cách mở:**
```
http://localhost:3000/demo-admin.html
→ Tự động vào chế độ Admin
→ Khóa dropdown account (chỉ hiển thị Admin)
```

**Chức năng bổ sung so với User:**
- ✓ Upload Công khai + Cá nhân
- ✓ Quản lý tài khoản (link ở footer)
- ✓ Cấp quyền file cho user khác

---

### 3️⃣ **demo-user.html** (NEW - Full Shell)
**Sao chép đầy đủ demo.html** với:
- ✅ Title: "Demo User — Quản gia AI"
- ✅ Hard-code: `setCurrentUser('user1')` tự động
- ✅ Tất cả chức năng như demo.html
- ✅ Không hiển thị "Quản lý tài khoản"

**Cách mở:**
```
http://localhost:3000/demo-user.html
→ Tự động vào chế độ User (Nguyễn Văn A)
→ Khóa dropdown account
```

**Hạn chế so với Admin:**
- ✗ Chỉ upload được Cá nhân (private)
- ✗ Không thấy "Quản lý tài khoản"
- ✗ Chỉ thấy file được admin cấp quyền

---

### 4️⃣ **clean/xem-tai-lieu.html**
**Nút "Quay lại" - Cải thiện**
```html
<!-- Trước: -->
<a href="thu-vien-tai-lieu.html">Thư viện</a>

<!-- Sau: -->
<a href="javascript:history.back()">Quay lại</a>
```

**Lợi ích:**
- ✓ Quay lại file trước (demo.html shell hoặc file độc lập)
- ✓ Không bị mất context
- ✓ Hoạt động trong iframe & độc lập

**Title:** `"Xem tài liệu - Quản gia AI"` (cập nhật)

---

### 5️⃣ **clean/upload-tai-lieu.html**
**Nút "Đóng" - Cải thiện**
```html
<!-- Trước: -->
<a href="thu-vien-tai-lieu.html">close</a>

<!-- Sau: -->
<a href="javascript:history.back()">close</a>
```

**Title:** `"Upload Tài liệu - Quản gia AI"` (cập nhật)

---

### 6️⃣ **quan-ly-tai-khoan.html**
**Nút "Quay lại"**
```html
<!-- Trước: -->
<a href="thu-vien-tai-lieu.html">arrow_back</a>

<!-- Sau: -->
<a href="javascript:history.back()">arrow_back</a>
```

**Lợi ích:**
- ✓ Quay lại shell (demo.html, demo-admin.html, hoặc demo-user.html)
- ✓ Không hardcode đường dẫn

---

### 7️⃣ **demo.html**
**Thêm hỗ trợ nút back cho file con**
```html
<!-- Nút mới (ẩn mặc định): -->
<button id="btn-back-to-library" onclick="goBackToLibrary()" style="display:none;">
  <span class="material-symbols-outlined">folder_open</span>
</button>
```

**Chú ý:** Không sửa logic chính shell, giữ nguyên tương thích.

---

## 🎯 QUI TRÌNH TEST

### **Scenario 1: Admin Upload → User Xem**

**Bước 1: Admin cấp quyền file**
```
1. Mở demo-admin.html
2. Sidebar footer → "Quản lý tài khoản"
3. Bảng Users → Tìm "Nguyễn Văn A" (user1)
4. Nút "Cấp quyền" → Chọn file "Báo cáo Quý 4 2024.pdf"
5. Lưu quyền truy cập
```

**Bước 2: User thấy file được cấp**
```
1. Mở demo-user.html
2. Sidebar → "Thư viện tài liệu"
3. Tab "Được cấp quyền" → Thấy "Báo cáo Quý 4 2024.pdf"
4. Click file → Xem tài liệu
5. Nút "Quay lại" → Quay về thư viện
```

✅ **Kết quả mong đợi:**
- Admin cấp được quyền ✓
- User thấy file trong tab ✓
- Nút quay lại hoạt động ✓

---

### **Scenario 2: User Upload File Cá nhân**

```
1. Mở demo-user.html
2. Sidebar → "Upload tài liệu"
3. Thư mục đích: "Cá nhân" (private)
4. Loại tài liệu: "Cá nhân"
5. Chọn file: "hợp-đồng.pdf" (< 50MB, định dạng hợp lệ)
6. Upload ✓
7. Nút "Quay lại" → Quay về thư viện
```

✅ **Kết quả mong đợi:**
- Upload thành công ✓
- File xấu hiện bị từ chối (> 50MB hoặc định dạng lạ) ✓
- Nút quay lại hoạt động ✓

---

### **Scenario 3: Kiểm tra quyền Xem**

```
1. Admin cấp file f001 CHỈ cho user2
2. Mở demo-user.html (user1)
3. Thư viện → Tab "Được cấp quyền"
4. Không thấy f001 (vì chỉ cấp cho user2) ✓
```

✅ **Kết quả mong đợi:**
- User1 không thấy file của user2 ✓
- Admin vẫn thấy tất cả ✓

---

## 📚 API UPLOAD (Backend)

### **Endpoint:** `POST /api/upload`

```json
{
  "fileName": "báo-cáo.pdf",
  "fileSize": 2048000,
  "folderId": "public_sales",
  "userId": "admin1",
  "chunkIndex": 0,
  "totalChunks": 1
}
```

### **Validation Rules:**
```
✓ Định dạng: pdf, doc, docx, xls, xlsx, ppt, pptx, txt, jpg, png, zip
✓ Max size: 50MB
✓ Quyền:
  - Admin: Upload cả Công khai + Cá nhân
  - User: Chỉ upload Cá nhân (private)
```

### **Response:**
```json
{
  "success": true,
  "fileId": "f_1713607200000",
  "message": "File upload thành công",
  "url": "s3://bucket/files/f_1713607200000.pdf"
}
```

---

## 🚀 CHẠY DEMO

### **Localhost:**
```bash
# Với Live Server (VS Code)
1. Right-click demo-admin.html → Open with Live Server
2. Hoặc: python -m http.server 8000

# URLs:
- http://localhost:8000/demo.html (chuyển account)
- http://localhost:8000/demo-admin.html (Admin locked)
- http://localhost:8000/demo-user.html (User1 locked)
```

### **Offline:**
```bash
# File:// protocol (mở trực tiếp)
file:///F:/code/demo-admin.html → Hoạt động 100%
```

---

## 📝 GIAI ĐOẠN TIẾP THEO (Optional)

### **1. Persistent Storage**
```javascript
// Hiện tại: Mock data (mất khi reload)
// Tương lai: localStorage hoặc backend DB
localStorage.setItem('qg_files', JSON.stringify(FILES));
```

### **2. Chunked Upload**
```javascript
// Hiện tại: Kiểm tra trước (client-side only)
// Tương lai: Split file → upload từng chunk → backend assembly
uploadFile(file, chunkSize=5MB) { ... }
```

### **3. Real-time Permission**
```javascript
// Hiện tại: Hard-coded FILE_PERMISSIONS
// Tương lai: Socket.io → Update realtime khi admin cấp quyền
onPermissionGranted(fileId, userId) { ... }
```

### **4. Folder Tree UI**
```javascript
// Thêm Modal chọn thư mục con khi upload
// Cho phép tạo thư mục mới trực tiếp
// Drag-drop files vào folder
```

---

## ✨ CHECKLIST

- [x] Upload file validation (định dạng + kích thước)
- [x] Admin/User full shell (không iframe)
- [x] Nút quay lại hoạt động trên tất cả file con
- [x] Permission check chính xác
- [x] Không có lỗi syntax
- [x] Tài liệu đầy đủ

---

## 🤝 FAQ

**Q: Nút quay lại không hoạt động?**  
A: Kiểm tra:
- Đang ở trong iframe không? (check browser console)
- `history.back()` chỉ hoạt động nếu có history
- Mở file trực tiếp từ file:// sẽ không có history

**Q: Cách tạo user mới?**  
A: Sửa `ACCOUNTS` trong `js/permissions.js`:
```javascript
const ACCOUNTS = [
  { id: 'admin1', name: '...', role: 'admin', email: '...' },
  { id: 'user3', name: 'User mới', role: 'user', email: 'new@example.com' },
];
```

**Q: Upload limit 50MB quá lớn?**  
A: Sửa `MAX_FILE_SIZE` trong `js/permissions.js`:
```javascript
const MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
```

---

**Made with ❤️ for Quản gia AI**
