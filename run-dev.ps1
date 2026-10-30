param([string]$ApiBaseUrl = 'http://127.0.0.1:8000/api/v1')
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
$listener = Get-NetTCPConnection -LocalPort 3000 -State Listen -ErrorAction SilentlyContinue
if ($listener) {
    throw "Port 3000 is already in use (PID: $($listener.OwningProcess -join ', ')). Reuse the existing PortfolioWeb instance or stop that process before starting another."
}
$flutter = Get-Command flutter -ErrorAction SilentlyContinue
$flutterPath = if ($flutter) { $flutter.Source } else { 'C:\Jatin\flutter\bin\flutter.bat' }
Write-Host "PortfolioWeb: http://localhost:3000 | API: $ApiBaseUrl"
& $flutterPath run -d chrome --web-hostname localhost --web-port 3000 "--dart-define=API_BASE_URL=$ApiBaseUrl"
exit $LASTEXITCODE
