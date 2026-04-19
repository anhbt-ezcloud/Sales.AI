@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1

color 0C

echo.
echo  ╔══════════════════════════════════════════════════════╗
echo  ║          QUẢN GIA AI  -  DỪNG DEMO SERVER            ║
echo  ╚══════════════════════════════════════════════════════╝
echo.

:: Tắt server trên các cổng 8080-8083
set KILLED=0

for %%P in (8080 8081 8082 8083) do (
    for /f "tokens=5" %%A in ('netstat -ano ^| findstr ":%%P " ^| findstr "LISTENING" 2^>nul') do (
        echo  [!] Tìm thấy tiến trình PID %%A đang chiếm cổng %%P, đang tắt...
        taskkill /PID %%A /F >nul 2>&1
        if !errorlevel! == 0 (
            echo  [✓] Đã tắt tiến trình PID %%A trên cổng %%P
            set KILLED=1
        ) else (
            echo  [X] Không thể tắt PID %%A (có thể cần quyền Admin)
        )
    )
)

if %KILLED% == 0 (
    echo  [i] Không tìm thấy server nào đang chạy trên cổng 8080-8083.
)

echo.
echo  Nhấn bất kỳ phím nào để đóng cửa sổ...
pause >nul
exit /b 0
