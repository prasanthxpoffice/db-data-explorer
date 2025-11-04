param(
  [string]$Server = "",
  [string]$Db = "IAS",
  [string]$In = "db\IAS.bacpac",
  [switch]$Replace  # drop existing DB first
)

$resolved = & "$PSScriptRoot\resolve-sqlserver.ps1" -Preferred $Server
Write-Host "Using server: $resolved"

if ($Replace) {
  # Drop existing DB if present
  sqlcmd -S $resolved -Q "IF DB_ID(N'$Db') IS NOT NULL BEGIN ALTER DATABASE [$Db] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE [$Db]; END"
}

function Resolve-SqlPackage {
  $candidates = @(
    'SqlPackage',
    "$env:UserProfile\.dotnet\tools\sqlpackage.exe",
    'C:\\Program Files\\Microsoft SQL Server\\170\\DAC\\bin\\SqlPackage.exe',
    'C:\\Program Files\\Microsoft SQL Server\\160\\DAC\\bin\\SqlPackage.exe',
    'C:\\Program Files\\Microsoft SQL Server\\150\\DAC\\bin\\SqlPackage.exe',
    'C:\\Program Files\\Microsoft SQL Server\\140\\DAC\\bin\\SqlPackage.exe',
    'C:\\Program Files\\Microsoft SQL Server\\DAC\\bin\\SqlPackage.exe'
  )
  foreach ($p in $candidates) {
    $cmd = Get-Command $p -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    if (Test-Path $p) { return $p }
  }
  throw 'Could not find SqlPackage.exe. See https://learn.microsoft.com/sql/tools/sqlpackage/sqlpackage-download'
}

$sqlpkg = Resolve-SqlPackage

& $sqlpkg /Action:Import `
          /TargetServerName:$resolved `
          /TargetDatabaseName:$Db `
          /SourceFile:$In

if ($LASTEXITCODE -ne 0) { throw "SqlPackage import failed." }
Write-Host "✅ Import complete: $In -> database $Db"
