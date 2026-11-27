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
#   3. Installs aria-links from the tap.
#
# Safe to re-run: every step is a no-op when already done.

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

brew install techytonys/tap/aria-links

echo ""
echo "Done — Aria Links is installed."
echo "One next step: run  aria-links login  and paste your API key"
echo "(find it in the Aria Links app, under Settings → API keys)."
