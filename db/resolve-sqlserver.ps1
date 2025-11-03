param(
  [string]$Preferred = ""
)

# If a server name was provided, just use it.
if ($Preferred -and $Preferred.Trim() -ne "") {
  Write-Output $Preferred
  exit 0
}

# Try the common LocalDB default first
$defaultLocalDb = "(localdb)\MSSQLLocalDB"

# Check if sqllocaldb exists
$hasLocalDb = Get-Command sqllocaldb -ErrorAction SilentlyContinue

if ($hasLocalDb) {
  # Start default LocalDB if present
  $info = & sqllocaldb info 2>$null
  if ($LASTEXITCODE -eq 0 -and $info -match "MSSQLLocalDB") {
    & sqllocaldb start "MSSQLLocalDB" 2>$null | Out-Null
    Write-Output $defaultLocalDb
    exit 0
  }

  # Otherwise pick the first available LocalDB instance, start it, and use it
  $instances = & sqllocaldb info 2>$null
  if ($LASTEXITCODE -eq 0) {
    foreach ($name in $instances) {
      if ([string]::IsNullOrWhiteSpace($name)) { continue }
      & sqllocaldb start $name 2>$null | Out-Null
      Write-Output "(localdb)\$name"
      exit 0
    }
  }
}

# Fallbacks for non-LocalDB environments
# Try a local default instance
Write-Output "localhost"
exit 0
