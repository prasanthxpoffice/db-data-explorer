@echo off
setlocal ENABLEDELAYEDEXPANSION
REM Usage:
REM   db-publish-dacpac.bat [ServerInstance] [DatabaseName] [DacpacFile] [/FROM_BACPAC path] [/TEMP tempDb] [/CLEANUP]

set SERVER_DEFAULT=(localdb)\MSSQLLocalDB
set DB_DEFAULT=IAS
set DAC_DEFAULT=db\IAS.dacpac
set LOG=db\publish-log.txt

if "%~1"=="" ( set "SERVER=%SERVER_DEFAULT%" ) else ( set "SERVER=%~1" )
if "%~2"=="" ( set "DB=%DB_DEFAULT%" ) else ( set "DB=%~2" )
if "%~3"=="" ( set "DACPAC=%DAC_DEFAULT%" ) else ( set "DACPAC=%~3" )

REM Optional flags
set "FROM_BACPAC="
set "TEMPDB="
set "CLEANUP="
set "TEMP_DEFAULT=%DB%_tmp"

REM Parse optional named args (simple fixed slots)
if /I "%~4"=="/FROM_BACPAC" set "FROM_BACPAC=%~5"
if /I "%~6"=="/FROM_BACPAC" set "FROM_BACPAC=%~7"
if /I "%~8"=="/FROM_BACPAC" set "FROM_BACPAC=%~9"

if /I "%~4"=="/TEMP" set "TEMPDB=%~5"
if /I "%~6"=="/TEMP" set "TEMPDB=%~7"
if /I "%~8"=="/TEMP" set "TEMPDB=%~9"

if /I "%~4"=="/CLEANUP" set "CLEANUP=1"
if /I "%~5"=="/CLEANUP" set "CLEANUP=1"
if /I "%~6"=="/CLEANUP" set "CLEANUP=1"
if /I "%~7"=="/CLEANUP" set "CLEANUP=1"
if /I "%~8"=="/CLEANUP" set "CLEANUP=1"
if /I "%~9"=="/CLEANUP" set "CLEANUP=1"

if "%TEMPDB%"=="" set "TEMPDB=%TEMP_DEFAULT%"

if not exist "db" mkdir "db" >nul 2>&1
echo ================== %DATE% %TIME% ================== > "%LOG%"
echo Using settings: >> "%LOG%"
echo   Server: %SERVER% >> "%LOG%"
echo   DB    : %DB% >> "%LOG%"
echo   Dacpac: %DACPAC% >> "%LOG%"
if not "%FROM_BACPAC%"=="" echo   From  : %FROM_BACPAC% >> "%LOG%"
if not "%FROM_BACPAC%"=="" echo   TempDB: %TEMPDB% >> "%LOG%"
if not "%CLEANUP%"=="" echo   Cleanup temp: yes >> "%LOG%"
echo. >> "%LOG%"

echo === Using settings ===
echo   Server: %SERVER%
echo   DB    : %DB%
echo   Dacpac: %DACPAC%
if not "%FROM_BACPAC%"=="" echo   From  : %FROM_BACPAC%
if not "%FROM_BACPAC%"=="" echo   TempDB: %TEMPDB%
if not "%CLEANUP%"=="" echo   Cleanup temp: yes
echo.

REM Try to start LocalDB (best effort)
where sqllocaldb >nul 2>&1
if %ERRORLEVEL% EQU 0 (
  sqllocaldb start MSSQLLocalDB >nul 2>&1
)

REM Locate SqlPackage first (used for extract/publish)
set "SQLPACKAGE="
for /f "delims=" %%i in ('where SqlPackage 2^>nul') do if not defined SQLPACKAGE set "SQLPACKAGE=%%i"
if "%SQLPACKAGE%"=="" if exist "%UserProfile%\.dotnet\tools\sqlpackage.exe" set "SQLPACKAGE=%UserProfile%\.dotnet\tools\sqlpackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\170\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\160\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\150\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe"
if "%SQLPACKAGE%"=="" if exist "C:\Program Files\Microsoft SQL Server\DAC\bin\SqlPackage.exe"   set "SQLPACKAGE=C:\Program Files\Microsoft SQL Server\DAC\bin\SqlPackage.exe"

if "%SQLPACKAGE%"=="" (
  echo [ERROR] Could not find SqlPackage.exe.
  echo Install it or add it to PATH: https://learn.microsoft.com/sql/tools/sqlpackage/sqlpackage-download >> "%LOG%"
  notepad "%LOG%"
  exit /b 1
) else (
  echo [OK] Using SqlPackage: "%SQLPACKAGE%" >> "%LOG%"
)

REM If BACPAC source is provided, import to temp and extract DACPAC from there
if not "%FROM_BACPAC%"=="" goto :from_bacpac

REM Ensure dacpac exists; if not, try to extract from current DB
if not exist "%DACPAC%" (
  echo [INFO] Dacpac not found; extracting from "%SERVER%"/"%DB%" ... >> "%LOG%"
  echo Extracting schema to "%DACPAC%" ...
  "%SQLPACKAGE%" /Action:Extract /SourceServerName:"%SERVER%" /SourceDatabaseName:"%DB%" /TargetFile:"%DACPAC%" >> "%LOG%" 2>&1
  if errorlevel 1 (
    echo [ERROR] Failed to extract dacpac from existing DB. >> "%LOG%"
    echo [ERROR] Dacpac not found and extract failed: "%DACPAC%".
    echo Hint: Import BACPAC to a temp DB and Extract a DACPAC, or use SSMS Extract Data-tier Application. >> "%LOG%"
    notepad "%LOG%"
    exit /b 1
  ) else (
    echo [OK] Extracted dacpac: "%DACPAC%" >> "%LOG%"
  )
) else (
  echo [OK] Found dacpac: "%DACPAC%" >> "%LOG%"
)

goto :have_dacpac

:from_bacpac
if not exist "%FROM_BACPAC%" (
  echo [ERROR] BACPAC not found: "%FROM_BACPAC%" >> "%LOG%"
  echo [ERROR] BACPAC not found: "%FROM_BACPAC%"
  notepad "%LOG%"
  exit /b 1
)

echo Preparing temp DB "%TEMPDB%" from BACPAC ... >> "%LOG%"
echo Preparing temp DB "%TEMPDB%" from BACPAC ...

REM Drop temp DB if exists (via sqlcmd or PowerShell)
where sqlcmd >nul 2>&1
if not errorlevel 1 (
  sqlcmd -S "%SERVER%" -Q "IF DB_ID(N'%TEMPDB%') IS NOT NULL BEGIN ALTER DATABASE [%TEMPDB%] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [%TEMPDB%]; END" >> "%LOG%" 2>&1
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ErrorActionPreference='Stop';" ^
    "$svr = '%SERVER%'; $db = '%TEMPDB%';" ^
    "$cs = \"Server=$svr;Database=master;Integrated Security=true;TrustServerCertificate=true\";" ^
    "Add-Type -AssemblyName System.Data;" ^
    "$cn = New-Object System.Data.SqlClient.SqlConnection $cs; $cn.Open();" ^
    "$cmd = $cn.CreateCommand();" ^
    "$cmd.CommandText = \"IF DB_ID(N'$db') IS NOT NULL BEGIN ALTER DATABASE [$db] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$db]; END\";" ^
    "$cmd.ExecuteNonQuery() | Out-Null; $cn.Close();" >> "%LOG%" 2>&1
)

echo Importing BACPAC "%FROM_BACPAC%" into temp DB "%TEMPDB%" ... >> "%LOG%"
"%SQLPACKAGE%" /Action:Import /TargetServerName:"%SERVER%" /TargetDatabaseName:"%TEMPDB%" /SourceFile:"%FROM_BACPAC%" >> "%LOG%" 2>&1
if errorlevel 1 (
  echo [ERROR] Import to temp DB failed. See log. >> "%LOG%"
  notepad "%LOG%"
  exit /b 1
)

echo Extracting DACPAC from temp DB "%TEMPDB%" to "%DACPAC%" ... >> "%LOG%"
"%SQLPACKAGE%" /Action:Extract /SourceServerName:"%SERVER%" /SourceDatabaseName:"%TEMPDB%" /TargetFile:"%DACPAC%" >> "%LOG%" 2>&1
if errorlevel 1 (
  echo [ERROR] Extract from temp DB failed. >> "%LOG%"
  notepad "%LOG%"
  exit /b 1
)

if not "%CLEANUP%"=="" (
  echo Dropping temp DB "%TEMPDB%" ... >> "%LOG%"
  where sqlcmd >nul 2>&1
  if not errorlevel 1 (
    sqlcmd -S "%SERVER%" -Q "IF DB_ID(N'%TEMPDB%') IS NOT NULL BEGIN ALTER DATABASE [%TEMPDB%] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [%TEMPDB%]; END" >> "%LOG%" 2>&1
  ) else (
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "$ErrorActionPreference='Stop';" ^
      "$svr = '%SERVER%'; $db = '%TEMPDB%';" ^
      "$cs = \"Server=$svr;Database=master;Integrated Security=true;TrustServerCertificate=true\";" ^
      "Add-Type -AssemblyName System.Data;" ^
      "$cn = New-Object System.Data.SqlClient.SqlConnection $cs; $cn.Open();" ^
      "$cmd = $cn.CreateCommand();" ^
      "$cmd.CommandText = \"IF DB_ID(N'$db') IS NOT NULL BEGIN ALTER DATABASE [$db] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$db]; END\";" ^
      "$cmd.ExecuteNonQuery() | Out-Null; $cn.Close();" >> "%LOG%" 2>&1
  )
)

echo [OK] Prepared DACPAC from BACPAC via temp DB. >> "%LOG%"

:have_dacpac

REM Publish dacpac (schema only, keep data)
echo Publishing schema to "%DB%" on "%SERVER%" ...
echo Publishing schema to "%DB%" on "%SERVER%" ... >> "%LOG%"
"%SQLPACKAGE%" /Action:Publish /TargetServerName:"%SERVER%" /TargetDatabaseName:"%DB%" /SourceFile:"%DACPAC%" ^
  /p:BlockOnPossibleDataLoss=false >> "%LOG%" 2>&1

set RC=%ERRORLEVEL%
echo SqlPackage exit code: %RC% >> "%LOG%"
if %RC% NEQ 0 (
  echo [ERROR] Publish failed. See log:
  type "%LOG%"
  notepad "%LOG%"
  exit /b %RC%
)

echo [OK] Publish complete. >> "%LOG%"
notepad "%LOG%"
exit /b 0
