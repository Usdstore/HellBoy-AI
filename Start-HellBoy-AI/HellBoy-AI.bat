@echo off
cd /d "%~dp0"

powershell -ExecutionPolicy Bypass -File ".\HellBoy-AI.ps1" start

pause