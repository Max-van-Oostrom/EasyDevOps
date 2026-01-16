# EasyDevOps Installation Script
# This script installs all prerequisites and runs the EasyDevOps application

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  EasyDevOps Installation Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# ============================================
# 1. Install .NET SDK 8
# ============================================
Write-Host "[1/4] Checking .NET SDK 8..." -ForegroundColor Yellow

$dotnetInstalled = $false
try {
    $dotnetVersion = dotnet --list-sdks 2>$null | Where-Object { $_ -match "^8\." }
    if ($dotnetVersion) {
        Write-Host "  .NET SDK 8 is already installed." -ForegroundColor Green
        $dotnetInstalled = $true
    }
} catch {
    $dotnetInstalled = $false
}

if (-not $dotnetInstalled) {
    Write-Host "  Installing .NET SDK 8..." -ForegroundColor Yellow
    
    # Download and run the official .NET install script
    $dotnetInstallScript = "$env:TEMP\dotnet-install.ps1"
    Invoke-WebRequest -Uri "https://dot.net/v1/dotnet-install.ps1" -OutFile $dotnetInstallScript
    
    # Install .NET SDK 8 (LTS)
    & $dotnetInstallScript -Channel 8.0 -InstallDir "$env:ProgramFiles\dotnet"
    
    # Add to PATH for current session
    $env:PATH = "$env:ProgramFiles\dotnet;$env:PATH"
    
    Write-Host "  .NET SDK 8 installed successfully." -ForegroundColor Green
}

# ============================================
# 2. Install Git
# ============================================
Write-Host "[2/4] Checking Git..." -ForegroundColor Yellow

$gitInstalled = $false
try {
    $gitVersion = git --version 2>$null
    if ($gitVersion) {
        Write-Host "  Git is already installed: $gitVersion" -ForegroundColor Green
        $gitInstalled = $true
    }
} catch {
    $gitInstalled = $false
}

if (-not $gitInstalled) {
    Write-Host "  Installing Git..." -ForegroundColor Yellow
    
    # Download Git for Windows installer
    $gitInstallerUrl = "https://github.com/git-for-windows/git/releases/download/v2.43.0.windows.1/Git-2.43.0-64-bit.exe"
    $gitInstaller = "$env:TEMP\Git-Installer.exe"
    
    Write-Host "  Downloading Git installer..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $gitInstallerUrl -OutFile $gitInstaller
    
    Write-Host "  Running Git installer (silent mode)..." -ForegroundColor Yellow
    Start-Process -FilePath $gitInstaller -ArgumentList "/VERYSILENT", "/NORESTART" -Wait
    
    # Refresh PATH
    $env:PATH = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    
    Write-Host "  Git installed successfully." -ForegroundColor Green
}

# ============================================
# 3. Clone the repository
# ============================================
Write-Host "[3/4] Cloning EasyDevOps repository..." -ForegroundColor Yellow

$repoUrl = "https://github.com/Max-van-Oostrom/EasyDevOps.git"
$cloneDir = "$env:USERPROFILE\EasyDevOps"

if (Test-Path $cloneDir) {
    Write-Host "  Repository folder already exists at $cloneDir" -ForegroundColor Yellow
    Write-Host "  Pulling latest changes..." -ForegroundColor Yellow
    Push-Location $cloneDir
    git pull
    Pop-Location
} else {
    Write-Host "  Cloning repository to $cloneDir..." -ForegroundColor Yellow
    git clone $repoUrl $cloneDir
}

Write-Host "  Repository ready." -ForegroundColor Green

# ============================================
# 4. Run the .NET frontend EasyDevOps app
# ============================================
Write-Host "[4/4] Running EasyDevOps application..." -ForegroundColor Yellow

$appPath = "$cloneDir\frontend\ConsoleApp1"

if (Test-Path $appPath) {
    Push-Location $appPath
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Application Output:" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    dotnet run
    
    Pop-Location
} else {
    Write-Host "  Error: Application path not found at $appPath" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
