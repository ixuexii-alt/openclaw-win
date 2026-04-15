# OpenClaw-Win Build Script for Windows
# Usage: powershell -ExecutionPolicy Bypass -File build-win.ps1

$ErrorActionPreference = "Stop"

Write-Host "=== OpenClaw-Win Windows Build ===" -ForegroundColor Cyan

# Check prerequisites
Write-Host "`n[1/5] Checking prerequisites..." -ForegroundColor Yellow
$nodeVersion = node --version 2>$null
if (-not $nodeVersion) {
    Write-Host "ERROR: Node.js is not installed. Download from https://nodejs.org" -ForegroundColor Red
    exit 1
}
Write-Host "  Node.js: $nodeVersion" -ForegroundColor Green

$npmVersion = npm --version 2>$null
Write-Host "  npm: $npmVersion" -ForegroundColor Green

# Build SDK first
Write-Host "`n[2/5] Building open-agent-sdk..." -ForegroundColor Yellow
Push-Location "$PSScriptRoot/open-agent-sdk"
if (-not (Test-Path "node_modules")) {
    npm install
}
npm run build
Pop-Location

# Install app dependencies
Write-Host "`n[3/5] Installing app dependencies..." -ForegroundColor Yellow
Push-Location "$PSScriptRoot/app"
npm install

# Run patches
Write-Host "`n[4/5] Applying SDK patches..." -ForegroundColor Yellow
node scripts/patch-open-agent-sdk.mjs

# Build Windows package
Write-Host "`n[5/5] Building Windows package..." -ForegroundColor Yellow
npm run package:win

Write-Host "`n=== Build complete! ===" -ForegroundColor Green
Write-Host "Output: app/dist/" -ForegroundColor Cyan
Pop-Location
