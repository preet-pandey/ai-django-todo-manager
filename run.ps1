Param(
    [string]$DatabaseUrl = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

$venvPython = Join-Path $root ".venv\Scripts\python.exe"

# Create venv if missing
if (!(Test-Path $venvPython)) {
    Write-Host "Creating virtual environment (.venv)..." -ForegroundColor Cyan
    python -m venv .venv
}

# Verify venv python
if (!(Test-Path $venvPython)) {
    Write-Error "Failed to create virtual environment. Ensure Python is installed and available on PATH."
    exit 1
}

# Optional: set database URL if provided
if ($DatabaseUrl) {
    $env:APP_DATABASE_URL = $DatabaseUrl
}

Write-Host "Installing dependencies..." -ForegroundColor Cyan
& $venvPython -m pip install --upgrade pip
& $venvPython -m pip install -r requirements.txt

Write-Host "Starting server at http://127.0.0.1:8000 ..." -ForegroundColor Green
# Launch a background job that opens the browser once the server is ready
$openUrl = "http://127.0.0.1:8000/docs"
Start-Job -ScriptBlock {
    param($url)
    for ($i=0; $i -lt 30; $i++) {
        try {
            $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 2
            if ($resp.StatusCode -ge 200 -and $resp.StatusCode -lt 500) {
                Start-Process $url
                break
            }
        } catch {
            Start-Sleep -Seconds 1
        }
    }
} -ArgumentList $openUrl | Out-Null

& $venvPython -m uvicorn app.main:app --reload