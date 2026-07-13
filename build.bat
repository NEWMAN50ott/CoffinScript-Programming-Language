@echo off
title CoffinScript Toolchain Build Driver
echo =======================================================
echo   csc Compiler Builder Engine (customasm Target)
echo =======================================================

where customasm >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] customasm utility was not found in your system PATH.
    echo Please install customasm (https://github.com) and try again.
    pause
    exit /b 1
)

echo Packing machine tokens into flat binary layout...
customasm csc.asm -f binary -o csc.bin

if %errorlevel% equ 0 (
    echo [SUCCESS] csc.bin generated successfully!
) else (
    echo [ERROR] Compilation failed. Check csc.asm syntax.
    exit /b 1
)
