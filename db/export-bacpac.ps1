param(
  [string]$Server = "",
  [string]$Db = "IAS",
  [string]$Out = "db\IAS.bacpac"
)

$resolved = & "$PSScriptRoot\resolve-sqlserver.ps1" -Preferred $Server
if (-not (Test-Path (Split-Path $Out))) { New-Item -ItemType Directory -Force -Path (Split-Path $Out) | Out-Null }

Write-Host "Using server: $resolved"
SqlPackage /Action:Export `
          /SourceServerName:$resolved `
          /SourceDatabaseName:$Db `
          /TargetFile:$Out

if ($LASTEXITCODE -ne 0) { throw "SqlPackage export failed." }
Write-Host "✅ Export complete: $Out"
