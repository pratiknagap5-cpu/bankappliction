@echo off
title Nexus Bank - Financial Transaction Management System
color 0A
echo =====================================================================
echo           NEXUS BANK - FINANCIAL TRANSACTION MANAGEMENT SYSTEM
echo =====================================================================
echo.
echo Starting Spring Boot Server on port 8080...
echo Once started, open your browser at: http://localhost:8080/login
echo.
echo Demo Credentials:
echo   - Customer: john / user123
echo   - Admin:    admin / admin123
echo.
echo Press Ctrl+C in this window anytime to stop the server.
echo =====================================================================
echo.

cd /d "%~dp0"
call .\mvnw.cmd spring-boot:run

pause
