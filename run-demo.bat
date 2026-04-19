@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

:: ============================================================
::  QUẢN GIA AI - DEMO LAUNCHER
::  Tự động chọn phương thức chạy server tốt nhất
:: ============================================================

color 0A

:: --- Banner ---
echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║          QUẢN GIA AI  -  SALES INTELLIGENCE          ║
echo  ║                    DEMO LAUNCHER                     ║
echo  ╚══════════════════════════════════════════════════════╝
echo.

:: ============================================================
::  Tìm cổng khả dụng (8080, 8081, 8082, 8083)
:: ============================================================
set PORT=
for %%P in (8080 8081 8082 8083) do (
    if not defined PORT (
        netstat -an | findstr ":%%P " | findstr "LISTENING" >nul 2>&1
        if errorlevel 1 (
            set PORT=%%P
        ) else (
            echo  [!] Cổng %%P đang bận, thử cổng tiếp theo...
        )
    )
)

if not defined PORT (
    echo.
    echo  [LỖI] Tất cả cổng 8080-8083 đều bận.
    echo  Vui lòng đóng bớt ứng dụng và thử lại.
    echo.
    pause
    exit /b 1
)

echo  [✓] Sẽ dùng cổng: %PORT%
echo.

:: ============================================================
::  BƯỚC 1: Kiểm tra Python
:: ============================================================
echo  [1/4] Kiểm tra Python...
python --version >nul 2>&1
if %errorlevel% == 0 (
    echo  [✓] Tìm thấy Python! Đang khởi động server...
    echo.
    echo  ┌────────────────────────────────────────────────────┐
    echo  │  Server: Python http.server                        │
    echo  │  Địa chỉ: http://localhost:%PORT%/demo.html        │
    echo  │  Nhấn Ctrl+C để dừng server và thoát              │
    echo  └────────────────────────────────────────────────────┘
    echo.

    :: Đợi 1 giây rồi mở trình duyệt (server cần thời gian khởi động)
    start "" "http://localhost:%PORT%/demo.html"
    timeout /t 1 /nobreak >nul
    python -m http.server %PORT%
    goto :done
)

:: ============================================================
::  BƯỚC 2: Kiểm tra Node.js
:: ============================================================
echo  [-] Không có Python.
echo  [2/4] Kiểm tra Node.js...
node --version >nul 2>&1
if %errorlevel% == 0 (
    echo  [✓] Tìm thấy Node.js! Đang khởi động http-server...
    echo.
    echo  ┌────────────────────────────────────────────────────┐
    echo  │  Server: Node.js http-server (npx)                 │
    echo  │  Địa chỉ: http://localhost:%PORT%/demo.html        │
    echo  │  Nhấn Ctrl+C để dừng server và thoát              │
    echo  └────────────────────────────────────────────────────┘
    echo.

    start "" "http://localhost:%PORT%/demo.html"
    timeout /t 2 /nobreak >nul
    npx --yes http-server -p %PORT% -c-1 --cors
    goto :done
)

:: ============================================================
::  BƯỚC 3: Dùng PowerShell tạo HTTP server đơn giản
::  (PowerShell có sẵn trên Windows 10/11)
:: ============================================================
echo  [-] Không có Node.js.
echo  [3/4] Thử khởi động server bằng PowerShell tích hợp sẵn...

:: Kiểm tra PowerShell có sẵn
powershell -command "exit 0" >nul 2>&1
if %errorlevel% == 0 (
    echo  [✓] Tìm thấy PowerShell! Đang khởi động server...
    echo.
    echo  ┌────────────────────────────────────────────────────┐
    echo  │  Server: PowerShell HttpListener                   │
    echo  │  Địa chỉ: http://localhost:%PORT%/demo.html        │
    echo  │  Nhấn Ctrl+C để dừng server và thoát              │
    echo  └────────────────────────────────────────────────────┘
    echo.

    :: Mở trình duyệt sau 2 giây để server kịp khởi động
    start "" cmd /c "timeout /t 2 /nobreak >nul && start http://localhost:%PORT%/demo.html"

    :: Script PowerShell khởi tạo HTTP server hoàn chỉnh
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "$port = %PORT%; $root = '%~dp0'; $root = $root.TrimEnd('\');" ^
        "$listener = New-Object System.Net.HttpListener;" ^
        "$listener.Prefixes.Add(\"http://localhost:$port/\");" ^
        "$listener.Start();" ^
        "Write-Host \"  Server đang chạy tại http://localhost:$port/\" -ForegroundColor Green;" ^
        "Write-Host \"  Nhấn Ctrl+C để dừng...\" -ForegroundColor Yellow;" ^
        "try {" ^
            "while ($listener.IsListening) {" ^
                "$ctx = $listener.GetContext();" ^
                "$req = $ctx.Request; $res = $ctx.Response;" ^
                "$url = $req.Url.LocalPath;" ^
                "if ($url -eq '/' -or $url -eq '') { $url = '/demo.html' };" ^
                "$file = Join-Path $root $url.TrimStart('/');" ^
                "$file = $file.Replace('/', '\\');" ^
                "if (Test-Path $file -PathType Leaf) {" ^
                    "$ext = [System.IO.Path]::GetExtension($file).ToLower();" ^
                    "$mime = switch ($ext) {" ^
                        "'.html' { 'text/html; charset=utf-8' }" ^
                        "'.css'  { 'text/css' }" ^
                        "'.js'   { 'application/javascript' }" ^
                        "'.png'  { 'image/png' }" ^
                        "'.jpg'  { 'image/jpeg' }" ^
                        "'.svg'  { 'image/svg+xml' }" ^
                        "'.ico'  { 'image/x-icon' }" ^
                        "default { 'application/octet-stream' }" ^
                    "};" ^
                    "$bytes = [System.IO.File]::ReadAllBytes($file);" ^
                    "$res.ContentType = $mime;" ^
                    "$res.ContentLength64 = $bytes.Length;" ^
                    "$res.OutputStream.Write($bytes, 0, $bytes.Length);" ^
                "} else {" ^
                    "$msg = [System.Text.Encoding]::UTF8.GetBytes('404 Not Found');" ^
                    "$res.StatusCode = 404;" ^
                    "$res.ContentLength64 = $msg.Length;" ^
                    "$res.OutputStream.Write($msg, 0, $msg.Length);" ^
                "};" ^
                "$res.OutputStream.Close();" ^
            "}" ^
        "} finally {" ^
            "$listener.Stop();" ^
            "Write-Host 'Server đã dừng.' -ForegroundColor Red;" ^
        "}"
    goto :done
)

:: ============================================================
::  BƯỚC 4: Fallback - Mở file trực tiếp bằng trình duyệt
:: ============================================================
echo  [-] Không có Python, Node.js, hoặc PowerShell phù hợp.
echo.
echo  [4/4] Mở trực tiếp bằng trình duyệt mặc định (chế độ giới hạn)...
echo.
color 0E
echo  ┌─────────────────────────────────────────────────────────┐
echo  │  CẢNH BÁO: Đang mở file trực tiếp (không có server)    │
echo  │  Một số tính năng iframe có thể không hoạt động.        │
echo  │                                                         │
echo  │  Để có trải nghiệm đầy đủ, hãy cài đặt một trong:      │
echo  │    • Python 3.x  (https://www.python.org/downloads/)    │
echo  │    • Node.js     (https://nodejs.org/)                  │
echo  └─────────────────────────────────────────────────────────┘
echo.

start "" "%~dp0demo.html"

echo  [✓] Demo đã được mở trong trình duyệt.
echo      Nhấn bất kỳ phím nào để đóng cửa sổ này...
pause >nul
exit /b 0

:done
echo.
echo  [✓] Server đã dừng. Tạm biệt!
exit /b 0
