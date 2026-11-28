# Aria Links - one-command installer for Windows.
#
#   irm https://raw.githubusercontent.com/techytonys/homebrew-tap/main/install.ps1 | iex
#
# What it does:
#   1. Downloads the Aria Links program (aria-links.exe) from the
#      v0.1.1 release - the same version Mac and Linux get - into
#      %LOCALAPPDATA%\Programs\aria-links\.
#   2. Adds that folder to your user PATH (once - re-running never
#      adds it twice), and to this window's PATH so the tool works
#      right away.
#   3. Self-checks that `aria-links` actually runs before declaring
#      success.
#
# Safe to re-run: every step heals or no-ops, so re-running this
# script repairs a partial install or refreshes the program file.

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch { }

$Version = "v0.1.1"
$DownloadUrl = "https://github.com/techytonys/aria-links-cli/releases/download/$Version/aria-links.exe"
$InstallDir = Join-Path $env:LOCALAPPDATA "Programs\aria-links"
$ExePath = Join-Path $InstallDir "aria-links.exe"

Write-Host ""
Write-Host "Installing Aria Links..."

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

# Download to a temp file first, then swap it in - a failed download
# never clobbers a working copy.
$TempExe = Join-Path $env:TEMP "aria-links-download.exe"
try {
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $TempExe -UseBasicParsing
} catch {
    Write-Host ""
    Write-Host "The download failed - check your connection and run this installer again."
    throw
}
Move-Item -Force -Path $TempExe -Destination $ExePath

# Add the install folder to the user PATH, idempotently.
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($null -eq $UserPath) { $UserPath = "" }
$PathEntries = $UserPath -split ";" | Where-Object { $_ -ne "" }
$AlreadyOnPath = $false
foreach ($entry in $PathEntries) {
    if ($entry.TrimEnd("\") -ieq $InstallDir.TrimEnd("\")) { $AlreadyOnPath = $true }
}
if (-not $AlreadyOnPath) {
    $NewUserPath = (@($PathEntries) + $InstallDir) -join ";"
    [Environment]::SetEnvironmentVariable("Path", $NewUserPath, "User")
    Write-Host "Added $InstallDir to your PATH."
}

# Make it usable in this window too.
if (($env:Path -split ";") -notcontains $InstallDir) {
    $env:Path = "$env:Path;$InstallDir"
}

# Self-check: success means the tool actually runs, not just that
# the file landed.
$VersionOut = $null
try { $VersionOut = & $ExePath --version } catch { }
$HelpOk = $false
try { & $ExePath --help | Out-Null; $HelpOk = ($LASTEXITCODE -eq 0) } catch { }

if ($VersionOut -and $HelpOk) {
    Write-Host ""
    Write-Host "OK: $VersionOut is installed and working."
} else {
    Write-Host ""
    Write-Host "aria-links was installed but didn't pass its self-check."
    Write-Host "Run this installer one more time - it repairs installs - and if"
    Write-Host "it still fails, note what 'aria-links --help' prints."
    exit 1
}

Write-Host ""
Write-Host "Done - Aria Links is installed."
Write-Host "One next step: run  aria-links login  and paste your API key"
Write-Host "(find it in the Aria Links app, under Settings -> API keys)."
Write-Host "If this window doesn't find aria-links, open a new terminal -"
Write-Host "new windows pick up the PATH change automatically."
