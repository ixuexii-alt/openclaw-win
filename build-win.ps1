# OpenClaw-Win Windows Build Script
# Usage: powershell -ExecutionPolicy Bypass -File build-win.ps1

$ErrorActionPreference = "Stop"

Write-Host "🔨 OpenClaw-Win Windows Build" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan

# Check Node.js
$nodeVersion = node --version 2>$null
if (-not $nodeVersion) {
    Write-Host "❌ Node.js not found. Install from https://nodejs.org/" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Node.js $nodeVersion" -ForegroundColor Green

# Check Git
$gitVersion = git --version 2>$null
if (-not $gitVersion) {
    Write-Host "⚠️  Git not found. Install from https://git-scm.com/downloads/win" -ForegroundColor Yellow
    Write-Host "   Git Bash is strongly recommended for full tool compatibility." -ForegroundColor Yellow
}
else {
    Write-Host "✅ $gitVersion" -ForegroundColor Green
}

# Navigate to app directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$appDir = Join-Path $scriptDir "app"
if (-not (Test-Path $appDir)) {
    $appDir = $scriptDir
}
Set-Location $appDir

# Install dependencies
Write-Host "`n📦 Installing dependencies..." -ForegroundColor Cyan
npm install
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Build
Write-Host "`n🏗️  Building..." -ForegroundColor Cyan
npm run package:win
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "`n✅ Build complete! Check the 'release' folder." -ForegroundColor Green
Write-Host "   Installer: release/*.exe" -ForegroundColor White
