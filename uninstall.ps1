# Aria Links - one-command uninstaller for Windows.
#
#   irm https://raw.githubusercontent.com/techytonys/homebrew-tap/main/uninstall.ps1 | iex
#
# What it does:
#   1. Removes the Aria Links program folder
#      (%LOCALAPPDATA%\Programs\aria-links\).
#   2. Removes that folder from your user PATH.
#   3. Removes your local config (%USERPROFILE%\.config\aria-links\),
#      which holds your API key - a full, clean uninstall.
#   4. Self-checks that `aria-links` is really gone before
#      declaring success.
#
# Safe to re-run: every step no-ops if there's nothing to do.

$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"

$InstallDir = Join-Path $env:LOCALAPPDATA "Programs\aria-links"
$ExePath = Join-Path $InstallDir "aria-links.exe"
$ConfigDir = Join-Path $HOME ".config\aria-links"

Write-Host "Uninstalling Aria Links..."
Write-Host "This removes the aria-links tool and your saved config"
Write-Host "(including your API key)."

# 1. Program folder.
if (Test-Path $InstallDir) {
    Remove-Item -Recurse -Force $InstallDir
    Write-Host "Removed $InstallDir."
} else {
    Write-Host "No program folder found at $InstallDir."
}

# 2. PATH entry (user PATH, plus this window's PATH).
$UserPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($null -ne $UserPath -and $UserPath -ne "") {
    $Kept = ($UserPath -split ";" | Where-Object {
        $_ -ne "" -and $_.TrimEnd("\") -ine $InstallDir.TrimEnd("\")
    })
    $NewUserPath = $Kept -join ";"
    if ($NewUserPath -ne $UserPath) {
        [Environment]::SetEnvironmentVariable("Path", $NewUserPath, "User")
        Write-Host "Removed $InstallDir from your PATH."
    }
}
$env:Path = (($env:Path -split ";" | Where-Object {
    $_ -ne "" -and $_.TrimEnd("\") -ine $InstallDir.TrimEnd("\")
}) -join ";")

# 3. Saved config (holds the API key).
if (Test-Path $ConfigDir) {
    Remove-Item -Recurse -Force $ConfigDir
    Write-Host "Removed your saved config ($ConfigDir) - your API key is gone from this machine."
} else {
    Write-Host "No saved config found at $ConfigDir."
}

# 4. Heads-up about a key set as an environment variable instead.
$EnvKey = [Environment]::GetEnvironmentVariable("ARIA_LINKS_API_KEY", "User")
if (-not $EnvKey) { $EnvKey = $env:ARIA_LINKS_API_KEY }
if ($EnvKey) {
    Write-Host "Heads-up: ARIA_LINKS_API_KEY is set as an environment variable."
    Write-Host "If you added it yourself, remove it too - this script doesn't"
    Write-Host "change your saved environment variables."
}

# Self-check.
$Failed = $false
if (Test-Path $ExePath) {
    Write-Host "aria-links.exe is still there: $ExePath"
    $Failed = $true
}
if (Test-Path $ConfigDir) {
    Write-Host "Your config folder is still there: $ConfigDir"
    $Failed = $true
}
if (Get-Command aria-links -ErrorAction SilentlyContinue) {
    Write-Host "aria-links is still on your PATH in this window - it may be"
    Write-Host "another copy, or this window's PATH is stale. Open a new"
    Write-Host "terminal to check."
    $Failed = $true
}
if ($Failed) {
    Write-Host "Run this uninstaller one more time; if it still fails, remove"
    Write-Host "the pieces above by hand."
    exit 1
}

Write-Host ""
Write-Host "OK: Aria Links is uninstalled."
