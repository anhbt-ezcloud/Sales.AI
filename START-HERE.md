# 🚀 QUICK START - Quản gia AI v2.1

## Các File Demo

### 1. **demo.html** (Chuyển Account)
- Dropdown account để thử admin/user/user2
- Chế độ **Development**
- URL: `http://localhost:8000/demo.html`

### 2. **demo-admin.html** ⭐ Admin Mode
- Tự động lock **Admin** (không chuyển được)
- Thấy "Quản lý tài khoản"
- Upload Công khai + Cá nhân
- URL: `http://localhost:8000/demo-admin.html`

### 3. **demo-user.html** ⭐ User Mode
- Tự động lock **User1** (Nguyễn Văn A)
- Upload chỉ Cá nhân
- Chỉ thấy file được cấp quyền
- URL: `http://localhost:8000/demo-user.html`

---

## 🔥 Test Nhanh 3 Phút

### **Bước 1: Admin cấp quyền**
```
1. Mở: demo-admin.html
2. Sidebar footer → "Quản lý tài khoản"
3. User1 → Cấp quyền → Chọn file → Lưu
```

### **Bước 2: User xem file**
```
1. Mở: demo-user.html (tab mới)
2. Sidebar → Thư viện tài liệu
3. Tab "Được cấp quyền" → Thấy file vừa cấp ✓
```

### **Bước 3: Upload file**
```
1. Sidebar → Upload tài liệu
2. Thư mục: Cá nhân
3. File < 50MB, định dạng hợp lệ
4. Upload ✓ → Quay lại ✓
```

---

## ✨ Tính Năng Mới

| Tính Năng | Chi Tiết |
|-----------|---------|
| **Upload Validation** | Kiểm tra định dạng (pdf, doc, xls, ...) & kích thước (max 50MB) |
| **Admin/User Shell** | Không còn iframe, full features |
| **Back Button** | Nút quay lại trên tất cả file con |
| **Permission System** | Admin cấp quyền → User thấy file |
| **Folder Manager** | Tạo/sửa/xóa/đặt tên thư mục |

---

## 📋 File Sửa

```
✅ js/permissions.js         → +180 lines (upload + validation)
✅ demo-admin.html            → New (full shell, hard-code admin)
✅ demo-user.html             → New (full shell, hard-code user1)
✅ clean/xem-tai-lieu.html    → Back button fix
✅ clean/upload-tai-lieu.html → Back button fix
✅ quan-ly-tai-khoan.html     → Back button fix
✅ demo.html                  → Minor: Add back button support
```

---

## 🔍 Kiểm Tra

**Các file không có lỗi:**
```
✓ js/permissions.js
✓ demo-admin.html
✓ demo-user.html
✓ quan-ly-tai-khoan.html
```

---

## 📞 Cần Giúp?

Xem chi tiết: `CACH-SUA-CHI-TIET.md`

Hỏi: Q&A phần dưới cùng file tài liệu

---

**Mở demo-admin.html hoặc demo-user.html để bắt đầu! 🎉**
