@echo off
setlocal ENABLEDELAYEDEXPANSION
REM Usage: db\import-bacpac.bat [ServerInstance] [DatabaseName] [InFile] [/REPLACE]

set SERVER_DEFAULT=(localdb)\MSSQLLocalDB
set DB_DEFAULT=IAS
set IN_DEFAULT=db\IAS.bacpac

if "%~1"=="" ( set "SERVER=%SERVER_DEFAULT%" ) else ( set "SERVER=%~1" )
if "%~2"=="" ( set "DB=%DB_DEFAULT%" ) else ( set "DB=%~2" )
if "%~3"=="" ( set "INFILE=%IN_DEFAULT%" ) else ( set "INFILE=%~3" )
set "REPLACE=%~4"

echo === Using settings ===
echo   Server: %SERVER%
echo   DB    : %DB%
echo   In    : %INFILE%
echo.

if not exist "%INFILE%" (
  echo [ERROR] Bacpac not found: "%INFILE%"
  exit /b 1
)

REM Locate SqlPackage.exe
set "SQLPACKAGE="
for %%P in (SqlPackage.exe) do ( if not "%%~$PATH:P"=="" set "SQLPACKAGE=%%~$PATH:P" )
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe"

if "%SQLPACKAGE%"=="" (
  echo [ERROR] Could not find SqlPackage.exe.
  exit /b 1
)

REM Optionally drop existing DB
if /I "%REPLACE%"=="/REPLACE" (
  where sqlcmd >nul 2>nul
  if errorlevel 1 (
    echo [WARN] sqlcmd not found; cannot drop existing DB automatically.
  ) else (
    echo Dropping existing database (if exists)...
    sqlcmd -S "%SERVER%" -Q "IF DB_ID(N'%DB%') IS NOT NULL BEGIN ALTER DATABASE [%DB%] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [%DB%]; END"
  )
)

echo Importing "%INFILE%" into database "%DB%" on "%SERVER%" ...
"%SQLPACKAGE%" /Action:Import /TargetServerName:"%SERVER%" /TargetDatabaseName:"%DB%" /SourceFile:"%INFILE%" /p:DatabaseMaximumSize=1024
if errorlevel 1 (
  echo [ERROR] SqlPackage import failed.
  exit /b 1
)

echo [OK] Import complete.
exit /b 0
