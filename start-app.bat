@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Step-by-step:
REM 1) cd server-dotnet
REM 2) dotnet run (in new window to keep server running)
REM 3) When server responds, open http://localhost:3000/ (or PORT)

REM Configure port (default 3000) and URL
if not defined PORT set "PORT=3000"
set "URL=http://localhost:%PORT%/"

REM If a server is already up, just open the client
powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; try { $r=Invoke-WebRequest -UseBasicParsing -Uri '%URL%' -Method Get -TimeoutSec 2 -ErrorAction Stop; exit 0 } catch { if ($_.Exception.Response) { exit 0 } else { exit 1 } }"
if not errorlevel 1 (
  echo Detected running server at %URL%. Opening browser...
  start "" "%URL%"
  exit /b 0
)

REM cd server-dotnet
set "ROOT=%~dp0"
set "SRV=%ROOT%server-dotnet"
if not exist "%SRV%" (
  echo [ERROR] Folder not found: %SRV%
  exit /b 1
)
pushd "%SRV%" || (
  echo [ERROR] Could not change directory to %SRV%
  exit /b 1
)

REM ensure dotnet exists
where dotnet >nul 2>nul
if errorlevel 1 (
  echo [ERROR] .NET SDK not found in PATH.
  echo Install .NET SDK from https://dotnet.microsoft.com/ and retry.
  popd
  exit /b 1
)

REM dotnet run (in a new window) with PORT set
echo Starting server: cd server-dotnet ^& dotnet run (PORT=%PORT%)
start "db-data-explorer server" cmd /k "set PORT=%PORT% && dotnet run"

REM go back to repo root
popd

REM wait for readiness then open the browser
echo Waiting for server to become ready at %URL% ...
set "MAX_ATTEMPTS=60"
for /L %%i in (1,1,%MAX_ATTEMPTS%) do (
  powershell -NoProfile -Command "$ProgressPreference='SilentlyContinue'; try { $r=Invoke-WebRequest -UseBasicParsing -Uri '%URL%' -Method Get -TimeoutSec 2 -ErrorAction Stop; exit 0 } catch { if ($_.Exception.Response) { exit 0 } else { exit 1 } }"
  if not errorlevel 1 goto :OPEN
  timeout /t 1 /nobreak >nul
  echo Attempt %%i/%MAX_ATTEMPTS% ...
)

echo [ERROR] Server did not become ready at %URL% in time.
echo        Check the server window for errors and retry.
exit /b 1

:OPEN
echo Server is up. Opening %URL% ...
start "" "%URL%"
exit /b 0
