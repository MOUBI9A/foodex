@echo off
REM Windows Quick Runner
REM Usage: run-windows.bat [debug|release|profile]

set MODE=%1
if "%MODE%"=="" set MODE=debug

echo 🪟 FoodEx - Windows Runner
echo ==========================

REM Check for Flutter
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter not found. Please install Flutter first.
    exit /b 1
)

REM Clean and prepare
echo 🔧 Preparing project...
flutter clean
flutter pub get

REM Enable Windows if not enabled
echo 🪟 Enabling Windows support...
flutter config --enable-windows-desktop

REM Run based on mode
if "%MODE%"=="release" (
    echo 🏗️ Building Windows app ^(Release^)...
    flutter build windows --release
    echo ✅ Windows app built: build\windows\runner\Release\
    echo 🚀 Launching app...
    start "" "build\windows\runner\Release\food_delivery.exe"
) else if "%MODE%"=="profile" (
    echo 📊 Running Windows app ^(Profile mode^)...
    flutter run -d windows --profile
) else (
    echo 🐛 Running Windows app ^(Debug mode^)...
    flutter run -d windows --debug --hot
)

echo ✅ Windows execution completed!
pause