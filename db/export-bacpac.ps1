param(
  [string]$Server = "",
  [string]$Db = "IAS",
  [string]$Out = "db\IAS.bacpac"
)

$resolved = & "$PSScriptRoot\resolve-sqlserver.ps1" -Preferred $Server
if (-not (Test-Path (Split-Path $Out))) { New-Item -ItemType Directory -Force -Path (Split-Path $Out) | Out-Null }

Write-Host "Using server: $resolved"
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

& $sqlpkg /Action:Export `
          /SourceServerName:$resolved `
          /SourceDatabaseName:$Db `
          /TargetFile:$Out

if ($LASTEXITCODE -ne 0) { throw "SqlPackage export failed." }
Write-Host "✅ Export complete: $Out"
