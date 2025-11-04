@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Start the db-data-explorer backend (Windows)
REM - Navigates to server/ and runs the API
REM - Installs dependencies if node_modules is missing

set "ROOT=%~dp0"
pushd "%ROOT%server" || (
  echo [ERROR] Could not change directory to "%ROOT%server".
  exit /b 1
)

REM Ensure Node.js is available
where node >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Node.js not found in PATH.
  echo Install from https://nodejs.org/ and retry.
  popd
  exit /b 1
)

REM Default ODBC driver for msnodesqlv8 if not set (LocalDB)
if "%SQL_ODBC_DRIVER%"=="" set "SQL_ODBC_DRIVER=ODBC Driver 18 for SQL Server"

REM Install dependencies if needed
if not exist "node_modules" (
  echo Installing server dependencies...
  where npm >nul 2>nul
  if errorlevel 1 (
    echo [WARN] npm not found; will attempt to run with node directly.
  ) else (
    call npm install || (
      echo [ERROR] npm install failed.
      popd
      exit /b 1
    )
  )
)

REM Prefer npm start if available; fallback to node server.js
where npm >nul 2>nul
if not errorlevel 1 (
  echo Starting server with npm start...
  call npm start
  set "RC=%ERRORLEVEL%"
) else (
  echo Starting server with node server.js...
  node server.js
  set "RC=%ERRORLEVEL%"
)

popd
exit /b %RC%
