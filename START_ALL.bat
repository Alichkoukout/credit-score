@echo off
REM Script de démarrage rapide - Credit Scoring Application
REM Quick Start Script

setlocal enabledelayedexpansion

color 0A
title Credit Scoring Application - Service Launcher

:menu
cls
echo ============================================
echo Credit Scoring Application - Service Menu
echo ============================================
echo.
echo 1. Start Backend (Spring Boot API)
echo 2. Start Frontend (Flutter App)
echo 3. Start Python-AI Service
echo 4. Start ALL Services
echo 5. Build Backend (Maven)
echo 6. Exit
echo.
set /p choice="Select option (1-6): "

if "%choice%"=="1" goto backend
if "%choice%"=="2" goto frontend
if "%choice%"=="3" goto python
if "%choice%"=="4" goto all
if "%choice%"=="5" goto build
if "%choice%"=="6" goto end

echo Invalid choice! Please try again.
timeout /t 2
goto menu

:backend
cls
echo ========== STARTING BACKEND ==========
echo.
set JAVA_HOME=C:\Program Files\Java\jdk-17
cd backend
echo Starting Spring Boot API...
echo Command: java -jar target\credit-scoring-backend-1.0.0.jar
echo.
java -jar target\credit-scoring-backend-1.0.0.jar
pause
goto menu

:frontend
cls
echo ========== STARTING FRONTEND ==========
echo.
cd frontend
echo Installing/Updating Flutter dependencies...
call flutter pub get
echo.
echo Launching Flutter application...
echo Command: flutter run
echo.
call flutter run
pause
goto menu

:python
cls
echo ========== STARTING PYTHON-AI SERVICE ==========
echo.
cd python-ai
echo Activating Python virtual environment...
call venv\Scripts\activate.bat
echo.
echo Starting Flask service...
echo Command: python app.py
echo.
python app.py
pause
goto menu

:all
cls
echo ========== STARTING ALL SERVICES ==========
echo.
echo Services will start in separate windows...
echo.

REM Backend
echo [1/3] Starting Backend...
start cmd /k "set JAVA_HOME=C:\Program Files\Java\jdk-17 && cd backend && java -jar target\credit-scoring-backend-1.0.0.jar"
timeout /t 3

REM Python-AI
echo [2/3] Starting Python-AI Service...
start cmd /k "cd python-ai && venv\Scripts\activate.bat && python app.py"
timeout /t 3

REM Frontend
echo [3/3] Starting Frontend (Flutter)...
cd frontend
call flutter pub get
call flutter run
pause
goto menu

:build
cls
echo ========== BUILDING BACKEND (Maven) ==========
echo.
set JAVA_HOME=C:\Program Files\Java\jdk-17
cd backend
echo Building project with Maven...
echo Command: mvn clean install -DskipTests
echo.
call mvn clean install -DskipTests
pause
goto menu

:end
echo.
echo Thank you for using Credit Scoring Application!
echo.
exit /b
