@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Start the client (index.html)
REM Usage:
REM   start-client.bat         -> opens http://localhost:3000 if reachable, else local index.html
REM   start-client.bat --file  -> opens local index.html directly

set "ROOT=%~dp0"
set "URL=http://localhost:3000"

if /I "%~1"=="--file" (
  echo Opening local file: "%ROOT%index.html"
  start "" "%ROOT%index.html"
  exit /b 0
)

REM Probe server; if not reachable, fall back to file
powershell -NoProfile -Command "try { $r=Invoke-WebRequest -UseBasicParsing -Uri '%URL%' -Method Head -TimeoutSec 2; exit 0 } catch { exit 1 }"
if errorlevel 1 (
  echo [WARN] Server not reachable at %URL%. Opening local file instead.
  start "" "%ROOT%index.html"
) else (
  echo Opening %URL%
  start "" "%URL%"
)

exit /b 0

