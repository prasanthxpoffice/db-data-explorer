@echo off
setlocal ENABLEDELAYEDEXPANSION

REM ============================================================
REM Export IAS -> db\IAS.bacpac and push to Git (Windows .bat)
REM Usage:
REM   db\export-and-push.bat [ServerInstance] [DatabaseName] [OutFile]
REM Examples:
REM   db\export-and-push.bat
REM   db\export-and-push.bat "(localdb)\ProjectsV13" IAS db\IAS.bacpac
REM ============================================================

REM ---- Defaults (can be overridden by args) ----
set SERVER_DEFAULT=(localdb)\MSSQLLocalDB
set DB_DEFAULT=IAS
set OUT_DEFAULT=db\IAS.bacpac

if "%~1"=="" ( set "SERVER=%SERVER_DEFAULT%" ) else ( set "SERVER=%~1" )
if "%~2"=="" ( set "DB=%DB_DEFAULT%" ) else ( set "DB=%~2" )
if "%~3"=="" ( set "OUT=%OUT_DEFAULT%" ) else ( set "OUT=%~3" )

echo === Using settings ===
echo   Server: %SERVER%
echo   DB    : %DB%
echo   Out   : %OUT%
echo.

REM ---- Ensure output folder exists ----
for %%F in ("%OUT%") do set "OUTDIR=%%~dpF"
if not exist "%OUTDIR%" (
  echo Creating output folder: "%OUTDIR%"
  mkdir "%OUTDIR%" 2>nul
)

REM ---- Locate SqlPackage.exe (common locations) ----
set "SQLPACKAGE="
REM Try PATH first
for %%P in (SqlPackage.exe) do (
  if not "%%~$PATH:P"=="" set "SQLPACKAGE=%%~$PATH:P"
)

REM Try common install paths (newest to oldest)
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "%UserProfile%\.dotnet\tools\sqlpackage.exe" set "SQLPACKAGE=%UserProfile%\.dotnet\tools\sqlpackage.exe"

if "%SQLPACKAGE%"=="" (
  echo [ERROR] Could not find SqlPackage.exe.
  echo Install it or add it to PATH: https://learn.microsoft.com/sql/tools/sqlpackage/sqlpackage-download
  exit /b 1
)

echo Found SqlPackage: "%SQLPACKAGE%"
echo.

REM ---- Export to bacpac ----
REM Try to start LocalDB (best effort)
sqllocaldb start MSSQLLocalDB >nul 2>nul
echo Exporting "%DB%" from "%SERVER%" to "%OUT%" ...
"%SQLPACKAGE%" /Action:Export /SourceServerName:"%SERVER%" /SourceDatabaseName:"%DB%" /TargetFile:"%OUT%"
if errorlevel 1 (
  echo.
  echo [ERROR] SqlPackage export failed.
  exit /b 1
)

echo.
echo [OK] Export complete: "%OUT%"
echo.

REM ---- Git add / commit / push ----
REM Ensure we are in repo root (this script usually run from repo root)
REM If you run it from elsewhere, 'cd /d' to your repo root first.

REM Verify git is available
where git >nul 2>nul
if errorlevel 1 (
  echo [WARN] git not found in PATH. Skipping commit/push.
  exit /b 0
)

REM Stage bacpac
git add "%OUT%"
if errorlevel 1 (
  echo [ERROR] git add failed.
  exit /b 1
)

REM Commit with timestamp
for /f "tokens=1-5 delims=/:. " %%a in ("%DATE% %TIME%") do (
  set COMMIT_TS=%%a %%b %%c %%d %%e
)
git commit -m "Update bacpac snapshot (%COMMIT_TS%)" 2>nul
if errorlevel 1 (
  echo [INFO] Nothing to commit (maybe no changes). Continuing to push...
)

REM Push
git push
if errorlevel 1 (
  echo [ERROR] git push failed.
  exit /b 1
)

echo.
echo [DONE] Exported and pushed successfully.
exit /b 0
