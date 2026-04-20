/**
 * permissions.js — Quản lý quyền và tài khoản
 * Chia sẻ giữa tất cả file demo (demo.html, demo-admin.html, demo-user.html)
 */

/* ══════════════════════════════════════
   MOCK DATA: TÀI KHOẢN
══════════════════════════════════════ */
const ACCOUNTS = [
  { id: 'admin1', name: 'Quản trị viên', role: 'admin', email: 'admin@example.com' },
  { id: 'user1',  name: 'Nguyễn Văn A',  role: 'user',  email: 'user1@example.com' },
  { id: 'user2',  name: 'Trần Thị B',    role: 'user',  email: 'user2@example.com' },
];

// Sẽ được override bởi từng file demo
let currentUser = ACCOUNTS[0]; // mặc định admin

/* ══════════════════════════════════════
   MOCK DATA: CẤU TRÚC THƯ MỤC & TÀI LIỆU
══════════════════════════════════════ */

// Cấu trúc thư mục
const FOLDER_TREE = {
  root: {
    id: 'root',
    name: 'Thư viện tài liệu',
    type: 'folder',
    children: [
      {
        id: 'public',
        name: 'Công khai',
        type: 'folder',
        children: [
          { id: 'public_sales', name: 'Sales', type: 'folder', children: [] },
          { id: 'public_accounting', name: 'Kế toán', type: 'folder', children: [] },
          { id: 'public_marketing', name: 'Marketing', type: 'folder', children: [] },
        ]
      },
      {
        id: 'private',
        name: 'Cá nhân',
        type: 'folder',
        children: []
      },
      {
        id: 'shared',
        name: 'Được chia sẻ với tôi',
        type: 'folder',
        children: []
      },
    ]
  }
};

// Danh sách tài liệu (mock)
const FILES = {
  'f001': { 
    id: 'f001', 
    name: 'Báo cáo Quý 4 2024.pdf', 
    ownerId: 'admin1', 
    type: 'pdf', 
    size: 2048, 
    createdAt: '2024-05-20',
    folderId: 'public_sales'
  },
  'f002': { 
    id: 'f002', 
    name: 'Kế hoạch bán hàng 2024.xlsx', 
    ownerId: 'admin1', 
    type: 'xlsx', 
    size: 512, 
    createdAt: '2024-05-19',
    folderId: 'public_accounting'
  },
  'f003': { 
    id: 'f003', 
    name: 'Chiến lược Marketing Q1.pptx', 
    ownerId: 'admin1', 
    type: 'pptx', 
    size: 1024, 
    createdAt: '2024-05-18',
    folderId: 'public_marketing'
  },
  'f004': { 
    id: 'f004', 
    name: 'Hợp đồng dự án ABC.pdf', 
    ownerId: 'user1', 
    type: 'pdf', 
    size: 768, 
    createdAt: '2024-05-17',
    folderId: 'private'
  },
  'f005': { 
    id: 'f005', 
    name: 'Tài liệu shared user2.docx', 
    ownerId: 'user2', 
    type: 'docx', 
    size: 384, 
    createdAt: '2024-05-16',
    folderId: 'shared'
  },
};

/* Quyền xem file: fileId => [userIds được xem] */
const FILE_PERMISSIONS = {
  'f001': ['user1', 'user2'],      // admin cấp cho user1 và user2
  'f002': ['user1'],                // admin cấp cho user1
  'f003': ['user2'],                // admin cấp cho user2
  'f004': [],                        // user1 tự upload, không cấp ai
  'f005': ['user1'],                // user2 share trực tiếp cho user1
};

/* ══════════════════════════════════════
   CORE FUNCTIONS: PHÂN QUYỀN
══════════════════════════════════════ */

/**
 * Kiểm tra user có thể upload vào folder type nào
 * @param {string} folderType - 'public' hoặc 'private'
 * @param {object} user - user object
 * @return {boolean}
 */
function canUploadTo(folderType, user) {
  if (user.role === 'admin') {
    return true; // admin upload được vào cả public và private
  }
  // user chỉ upload được vào private (cá nhân)
  return folderType === 'private';
}

/**
 * Kiểm tra user có thể xem file
 * @param {object} file - file object
 * @param {object} user - user object
 * @return {boolean}
 */
function canView(file, user) {
  if (user.role === 'admin') {
    return true; // admin thấy mọi file (hoặc có option xem riêng)
  }
  
  // user chỉ thấy:
  // 1. File mình tự upload
  if (file.ownerId === user.id) return true;
  
  // 2. File được admin cấp quyền
  const perms = FILE_PERMISSIONS[file.id] || [];
  if (perms.includes(user.id)) return true;
  
  // 3. File được share trực tiếp (check thêm nếu cần)
  
  return false;
}

/**
 * Lấy danh sách file user được phép xem
 * @param {object} user
 * @return {array} file objects
 */
function getVisibleFiles(user) {
  return Object.values(FILES).filter(file => canView(file, user));
}

/**
 * Lấy danh sách file trong folder cụ thể, filter theo quyền
 * @param {string} folderId
 * @param {object} user
 * @return {array} file objects
 */
function getFilesInFolder(folderId, user) {
  return Object.values(FILES)
    .filter(file => file.folderId === folderId && canView(file, user));
}

/**
 * Cấp quyền xem file cho user(s)
 * @param {string} fileId
 * @param {array} userIds
 */
function grantFilePermission(fileId, userIds) {
  FILE_PERMISSIONS[fileId] = userIds;
}

/**
 * Thêm file mới
 * @param {object} fileObj - { id, name, ownerId, type, size, folderId }
 */
function addFile(fileObj) {
  FILES[fileObj.id] = fileObj;
  if (!FILE_PERMISSIONS[fileObj.id]) {
    FILE_PERMISSIONS[fileObj.id] = [];
  }
}

/**
 * Xóa file
 * @param {string} fileId
 */
function deleteFile(fileId) {
  delete FILES[fileId];
  delete FILE_PERMISSIONS[fileId];
}

/**
 * Lấy badge text số lượng người được cấp quyền (dùng cho admin)
 * @param {string} fileId
 * @return {string}
 */
function getPermissionBadge(fileId) {
  const count = (FILE_PERMISSIONS[fileId] || []).length;
  return count > 0 ? `Đã cấp cho ${count} người` : 'Chưa cấp';
}

/**
 * Lấy danh sách tài khoản (dùng cho dropdown chuyển account trong demo.html)
 * @return {array}
 */
function getAccountsList() {
  return ACCOUNTS;
}

/**
 * Set current user (dùng khi demo.html chuyển account)
 * @param {string} userId
 */
function setCurrentUser(userId) {
  const user = ACCOUNTS.find(a => a.id === userId);
  if (user) {
    currentUser = user;
    return true;
  }
  return false;
}

/**
 * Lấy user hiện tại
 * @return {object}
 */
function getCurrentUser() {
  return currentUser;
}

/**
 * Kiểm tra user có phải admin
 * @param {object} user
 * @return {boolean}
 */
function isAdmin(user) {
  return user && user.role === 'admin';
}

/**
 * Lấy số lượng tài liệu được cấp quyền cho user
 * @param {string} userId
 * @return {number}
 */
function countGrantedFiles(userId) {
  let count = 0;
  for (const [fileId, userIds] of Object.entries(FILE_PERMISSIONS)) {
    if (userIds.includes(userId)) count++;
  }
  return count;
}

/* ══════════════════════════════════════
   HELPER: THAO TÁC FOLDER
══════════════════════════════════════ */

/**
 * Lấy node folder từ ID
 * @param {string} folderId
 * @return {object}
 */
function getFolderById(folderId) {
  function search(node) {
    if (node.id === folderId) return node;
    if (node.children) {
      for (const child of node.children) {
        const result = search(child);
        if (result) return result;
      }
    }
    return null;
  }
  return search(FOLDER_TREE.root);
}

/**
 * Thêm folder con
 * @param {string} parentFolderId
 * @param {object} newFolder - { id, name, type: 'folder' }
 * @return {boolean}
 */
function addFolderToParent(parentFolderId, newFolder) {
  const parent = getFolderById(parentFolderId);
  if (!parent || parent.type !== 'folder') return false;
  if (!parent.children) parent.children = [];
  parent.children.push(newFolder);
  return true;
}

/**
 * Xóa folder (cascade children)
 * @param {string} folderId
 * @return {boolean}
 */
function deleteFolder(folderId) {
  function searchAndDelete(node) {
    if (!node.children) return false;
    const idx = node.children.findIndex(c => c.id === folderId);
    if (idx !== -1) {
      node.children.splice(idx, 1);
      return true;
    }
    for (const child of node.children) {
      if (searchAndDelete(child)) return true;
    }
    return false;
  }
  return searchAndDelete(FOLDER_TREE.root);
}

/**
 * Đổi tên folder
 * @param {string} folderId
 * @param {string} newName
 * @return {boolean}
 */
function renameFolder(folderId, newName) {
  const folder = getFolderById(folderId);
  if (folder) {
    folder.name = newName;
    return true;
  }
  return false;
}

/* ══════════════════════════════════════
   UPLOAD FILE & VALIDATION
══════════════════════════════════════ */

/**
 * Danh sách loại file được phép upload
 */
const ALLOWED_EXTENSIONS = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'jpg', 'png', 'zip'];
const MAX_FILE_SIZE = 50 * 1024 * 1024; // 50 MB

/**
 * Xác thực file trước upload
 * @param {string} fileName - tên file
 * @param {number} fileSize - kích thước file (bytes)
 * @return {object} { valid: boolean, message: string }
 */
function validateFile(fileName, fileSize) {
  const result = { valid: false, message: '' };
  
  if (!fileName) {
    result.message = 'Tên file không được để trống';
    return result;
  }
  
  const ext = fileName.split('.').pop().toLowerCase();
  if (!ALLOWED_EXTENSIONS.includes(ext)) {
    result.message = `Định dạng file không hỗ trợ. Chỉ hỗ trợ: ${ALLOWED_EXTENSIONS.join(', ')}`;
    return result;
  }
  
  if (fileSize > MAX_FILE_SIZE) {
    result.message = `File quá lớn. Tối đa 50MB, file của bạn ${(fileSize / 1024 / 1024).toFixed(1)}MB`;
    return result;
  }
  
  result.valid = true;
  result.message = 'OK';
  return result;
}

/**
 * Upload file (simulation - backend sẽ validate lại)
 * @param {string} fileName
 * @param {number} fileSize
 * @param {string} folderId
 * @param {object} user
 * @return {object} { success: boolean, fileId: string, message: string }
 */
function uploadFile(fileName, fileSize, folderId, user) {
  const result = { success: false, fileId: null, message: '' };
  
  // Kiểm tra quyền upload vào folder
  const folder = getFolderById(folderId);
  if (!folder) {
    result.message = 'Thư mục không tồn tại';
    return result;
  }
  
  if (folder.id === 'public') {
    if (!isAdmin(user)) {
      result.message = 'Chỉ admin mới có thể upload vào thư mục Công khai';
      return result;
    }
  } else if (folder.id === 'private') {
    // user cá nhân chỉ upload vào private của mình
    // (simplification: assume private folder is always accessible to current user)
  } else if (folder.id.startsWith('public_')) {
    if (!isAdmin(user)) {
      result.message = 'Chỉ admin mới có thể upload vào thư mục Công khai';
      return result;
    }
  }
  
  // Xác thực file
  const validation = validateFile(fileName, fileSize);
  if (!validation.valid) {
    result.message = validation.message;
    return result;
  }
  
  // Tạo file ID mới
  const timestamp = Date.now();
  const fileId = 'f_' + timestamp;
  
  // Tạo file object
  const fileObj = {
    id: fileId,
    name: fileName,
    ownerId: user.id,
    type: fileName.split('.').pop().toLowerCase(),
    size: fileSize,
    createdAt: new Date().toISOString().split('T')[0],
    folderId: folderId
  };
  
  // Lưu file
  addFile(fileObj);
  
  result.success = true;
  result.fileId = fileId;
  result.message = `File "${fileName}" upload thành công`;
  return result;
}

/**
 * Lấy danh sách upload server URLs (mock)
 * Trong thực tế, backend sẽ cung cấp URL tạm thời signed
 */
function getUploadServerConfig() {
  return {
    uploadUrl: 'https://api.example.com/upload', // backend
    validator: 'https://api.example.com/validate-file', // backend check file
    maxRetries: 3,
    chunkSize: 5 * 1024 * 1024, // 5 MB chunks
    timeout: 30000 // 30s
  };
}
