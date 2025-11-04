@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Start the db-data-explorer backend (.NET Minimal API)
REM - Navigates to server-dotnet/ and runs the API

set "ROOT=%~dp0"
pushd "%ROOT%server-dotnet" || (
  echo [ERROR] Could not change directory to "%ROOT%server-dotnet".
  exit /b 1
)

REM Ensure .NET SDK is available
where dotnet >nul 2>nul
if errorlevel 1 (
  echo [ERROR] .NET SDK not found in PATH.
  echo Install .NET SDK (https://dotnet.microsoft.com/) and retry.
  popd
  exit /b 1
)

REM Use PORT from root .env if present
for /f "tokens=* usebackq" %%i in (`powershell -NoProfile -Command "$env:PORT"`) do set "PORT=%%i"

echo Starting .NET API (port %PORT% ^(if set^))...
dotnet run
set "RC=%ERRORLEVEL%"

popd
exit /b %RC%
