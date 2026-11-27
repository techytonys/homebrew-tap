#!/usr/bin/env bash
#
# Aria Links — one-command installer.
#
#   curl -fsSL https://raw.githubusercontent.com/techytonys/homebrew-tap/main/install.sh | bash
#
# What it does:
#   1. If Homebrew is missing, installs it with Apple's official
#      Homebrew installer — in the foreground, with its normal
#      prompts (press Return, type YOUR password). Nothing here
#      bypasses or automates the password prompt.
#   2. Loads brew into this shell (Apple Silicon / Intel / Linux).
#   3. Installs aria-links from the tap — or, if aria-links is
#      already installed (finished, partial, or outdated), updates
#      the tap and reinstalls it clean, so re-running this script
#      repairs a bad install.
#   4. Self-checks that `aria-links` actually runs before declaring
#      success.
#
# Safe to re-run: every step heals or no-ops.

set -euo pipefail

load_brew() {
  local prefix
  for prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew "${HOME}/.linuxbrew"; do
    if [ -x "${prefix}/bin/brew" ]; then
      eval "$("${prefix}/bin/brew" shellenv)"
      return 0
    fi
  done
  return 1
}

if ! command -v brew >/dev/null 2>&1; then
  load_brew || true
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew isn't installed yet — installing it now."
  echo "The official installer will ask you to press Return and type your password."
  # The installer script arrives as an argument (not on stdin), and
  # stdin is the terminal, so its prompts work exactly as usual.
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/tty
  if ! load_brew; then
    echo "Homebrew was installed but couldn't be loaded into this shell."
    echo "Open a new terminal window and run this installer again."
    exit 1
  fi
fi

echo ""
echo "Installing Aria Links…"
echo ""
echo "One heads-up: Homebrew's Node package prints a standard note that"
echo "says \"Single Executable Application is disabled as it doesn't work"
echo "with shared libnode.\" That note is about Node itself — it is NOT"
echo "an error, and Aria Links doesn't use that feature. Aria Links is a"
echo "plain script; if you see that line, the install is still on track."

if brew list --formula aria-links >/dev/null 2>&1; then
  echo ""
  echo "aria-links is already installed — updating and reinstalling it"
  echo "clean, so a partial or outdated install gets repaired."
  brew update
  brew reinstall techytonys/tap/aria-links
else
  brew install techytonys/tap/aria-links
fi

# Self-check: success means the tool actually runs, not just that
# Homebrew copied files.
if command -v aria-links >/dev/null 2>&1 && aria-links --help >/dev/null 2>&1; then
  echo ""
  echo "✓ $(aria-links --version) is installed and working."
else
  echo ""
  echo "aria-links was installed but didn't pass its self-check."
  echo "Run this installer one more time — it repairs installs — and if"
  echo "it still fails, note what 'aria-links --help' prints."
  exit 1
fi

echo ""
echo "Done — Aria Links is installed."
echo "One next step: run  aria-links login  and paste your API key"
echo "(find it in the Aria Links app, under Settings → API keys)."
