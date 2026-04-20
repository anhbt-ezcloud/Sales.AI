@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║       QUẢN GIA AI  -  ĐÓNG GÓI DỰ ÁN              ║
echo  ╚══════════════════════════════════════════════════════╝
echo.

set PACKAGE=QuanGiaAI-Demo
set ZIPFILE=QuanGiaAI-Demo.zip

:: ── Kiểm tra PowerShell ─────────────────────────────────────
where powershell >nul 2>&1
if errorlevel 1 (
    echo  [LỖI] Không tìm thấy PowerShell. Cần PowerShell 5.0+.
    pause & exit /b 1
)

:: ── Dọn dẹp file cũ ────────────────────────────────────────
if exist "%PACKAGE%" (
    echo  Xóa thư mục tạm cũ...
    rmdir /s /q "%PACKAGE%"
)
if exist "%ZIPFILE%" (
    echo  Xóa file zip cũ...
    del /q "%ZIPFILE%"
)
echo.

:: ── Bước 1: Tạo cấu trúc thư mục ──────────────────────────
echo  [1/5] Tạo cấu trúc thư mục...
mkdir "%PACKAGE%"
mkdir "%PACKAGE%\docs"
mkdir "%PACKAGE%\docs\file-thiet-ke"

:: ── Bước 2: Sao chép file chính ────────────────────────────
echo  [2/5] Sao chép các file chính...
for %%F in (run-demo.bat stop-demo.bat README.txt) do (
    if exist "%%F" (
        copy "%%F" "%PACKAGE%\%%F" >nul
    ) else (
        echo     [!] Cảnh báo: Không tìm thấy %%F
    )
)

:: ── Bước 3: Sao chép & điều chỉnh demo.html ────────────────
echo  [3/5] Điều chỉnh demo.html (đường dẫn: clean/ → docs/file-thiet-ke/)...
if not exist "demo.html" (
    echo  [LỖI] Không tìm thấy demo.html
    goto :cleanup
)
powershell -NoProfile -Command ^
    "(Get-Content 'demo.html' -Raw -Encoding UTF8)" ^
    " -replace 'clean/', 'docs/file-thiet-ke/'" ^
    " | Set-Content '%PACKAGE%\demo.html' -Encoding UTF8 -NoNewline"
if errorlevel 1 (
    echo  [LỖI] Không thể xử lý demo.html
    goto :cleanup
)

:: ── Bước 4: Sao chép các file màn hình ─────────────────────
echo  [4/5] Sao chép file màn hình vào docs\file-thiet-ke...
if not exist "clean\" (
    echo  [LỖI] Không tìm thấy thư mục clean\
    goto :cleanup
)
copy "clean\*.html" "%PACKAGE%\docs\file-thiet-ke\" >nul
:: Đếm số file đã copy
set COUNT=0
for %%F in ("%PACKAGE%\docs\file-thiet-ke\*.html") do set /a COUNT+=1
echo     → Đã sao chép !COUNT! file màn hình

:: ── Bước 5: Nén thành ZIP ───────────────────────────────────
echo  [5/5] Nén thành %ZIPFILE%...
powershell -NoProfile -Command ^
    "Compress-Archive -Path '%PACKAGE%' -DestinationPath '%ZIPFILE%' -Force"
if errorlevel 1 (
    echo  [LỖI] Không thể tạo file ZIP!
    goto :cleanup
)

:: ── Dọn dẹp thư mục tạm ─────────────────────────────────────
:cleanup
if exist "%PACKAGE%" rmdir /s /q "%PACKAGE%"

:: ── Kết quả ─────────────────────────────────────────────────
echo.
if exist "%ZIPFILE%" (
    for %%A in ("%ZIPFILE%") do set SIZE=%%~zA
    echo  ╔══════════════════════════════════════════════════════╗
    echo  ║  THÀNH CÔNG! File đã sẵn sàng gửi đi:             ║
    echo  ║                                                      ║
    echo  ║    QuanGiaAI-Demo.zip                               ║
    echo  ║                                                      ║
    echo  ║  Cấu trúc bên trong:                               ║
    echo  ║    QuanGiaAI-Demo\                                  ║
    echo  ║    ├── run-demo.bat   (double-click để chạy)       ║
    echo  ║    ├── stop-demo.bat                                ║
    echo  ║    ├── README.txt                                   ║
    echo  ║    ├── demo.html                                    ║
    echo  ║    └── docs\file-thiet-ke\*.html                   ║
    echo  ╚══════════════════════════════════════════════════════╝
    echo.
    echo  Kích thước: !SIZE! bytes
) else (
    echo  [LỖI] Đóng gói thất bại. Kiểm tra lại các file nguồn.
)

echo.
pause
