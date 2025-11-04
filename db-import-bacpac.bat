@echo off
setlocal ENABLEDELAYEDEXPANSION
REM Usage: db-import-bacpac.bat [ServerInstance] [DatabaseName] [InFile] [/REPLACE]

set SERVER_DEFAULT=(localdb)\MSSQLLocalDB
set DB_DEFAULT=IAS
set IN_DEFAULT=db\IAS.bacpac
set LOG=db\import-log.txt

if "%~1"=="" ( set "SERVER=%SERVER_DEFAULT%" ) else ( set "SERVER=%~1" )
if "%~2"=="" ( set "DB=%DB_DEFAULT%" ) else ( set "DB=%~2" )
if "%~3"=="" ( set "INFILE=%IN_DEFAULT%" ) else ( set "INFILE=%~3" )
set "REPLACE=%~4"

if not exist "db" mkdir "db" >nul 2>&1
echo ================== %DATE% %TIME% ================== > "%LOG%"
echo Using settings: >> "%LOG%"
echo   Server: %SERVER% >> "%LOG%"
echo   DB    : %DB% >> "%LOG%"
echo   In    : %INFILE% >> "%LOG%"
echo. >> "%LOG%"

echo === Using settings ===
echo   Server: %SERVER%
echo   DB    : %DB%
echo   In    : %INFILE%
echo.

REM Try to start LocalDB (best effort)
where sqllocaldb >nul 2>&1
if %ERRORLEVEL% EQU 0 (
  sqllocaldb start MSSQLLocalDB >nul 2>&1
)

if not exist "%INFILE%" (
  echo [ERROR] Bacpac not found: "%INFILE%"
  echo [ERROR] Bacpac not found: "%INFILE%" >> "%LOG%"
  notepad "%LOG%"
  pause >nul
  exit /b 1
) else (
  echo [OK] Found bacpac: "%INFILE%" >> "%LOG%"
)

REM --- Locate SqlPackage.exe: PATH (includes dotnet tools) then common folders ---
set "SQLPACKAGE="
for /f "delims=" %%i in ('where SqlPackage 2^>nul') do if not defined SQLPACKAGE set "SQLPACKAGE=%%i"
if "%SQLPACKAGE%"=="" if exist "%UserProfile%\.dotnet\tools\sqlpackage.exe" set "SQLPACKAGE=%UserProfile%\.dotnet\tools\sqlpackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\DAC\bin\SqlPackage.exe"   set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\DAC\bin\SqlPackage.exe"

if not "%SQLPACKAGE%"=="" (
  echo [OK] Using SqlPackage: "%SQLPACKAGE%" >> "%LOG%"
) else (
  echo [ERROR] Could not find SqlPackage.exe. >> "%LOG%"
  echo Get it here: https://learn.microsoft.com/sql/tools/sqlpackage/sqlpackage-download >> "%LOG%"
  echo [ERROR] Could not find SqlPackage.exe.
  notepad "%LOG%"
  pause >nul
  exit /b 1
)

REM --- Optional drop existing DB ---
if /I "%REPLACE%"=="/REPLACE" (
  where sqlcmd >nul 2>&1
  if errorlevel 1 (
    echo [WARN] sqlcmd not found; cannot drop existing DB automatically. >> "%LOG%"
  ) else (
    echo Dropping existing database (if exists)... >> "%LOG%"
    sqlcmd -S "%SERVER%" -Q "IF DB_ID(N'%DB%') IS NOT NULL BEGIN ALTER DATABASE [%DB%] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [%DB%]; END" >> "%LOG%" 2>&1
  )
)

echo Importing "%INFILE%" into database "%DB%" on "%SERVER%" ...
echo Importing "%INFILE%" into database "%DB%" on "%SERVER%" ... >> "%LOG%"

"%SQLPACKAGE%" ^
  /Action:Import ^
  /TargetServerName:"%SERVER%" ^
  /TargetDatabaseName:"%DB%" ^
  /SourceFile:"%INFILE%" >> "%LOG%" 2>&1

set RC=%ERRORLEVEL%
echo SqlPackage exit code: %RC% >> "%LOG%"

if %RC% NEQ 0 (
  echo [ERROR] SqlPackage import failed. See log:
  type "%LOG%"
  notepad "%LOG%"
  pause >nul
  exit /b %RC%
)

echo [OK] Import complete. >> "%LOG%"
echo.
echo =============================
echo ✅ Import completed successfully
notepad "%LOG%"
pause >nul
exit /b 0
