#!/usr/bin/env bash
#
# Aria Links — one-command uninstaller.
#
#   curl -fsSL https://raw.githubusercontent.com/techytonys/homebrew-tap/main/uninstall.sh | bash
#
# What it does:
#   1. Uninstalls the aria-links formula if it's installed.
#   2. Removes your local config (~/.config/aria-links/), which
#      holds your API key — a full, clean uninstall.
#   3. Untaps techytonys/tap once the formula is gone.
#   4. Self-checks that `aria-links` is really gone before
#      declaring success.
#
# What it does NOT do: it never touches Homebrew itself or Node —
# other tools may depend on them. It removes only Aria Links' own
# pieces. Safe to re-run: every step no-ops if there's nothing to do.

set -uo pipefail

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

echo "Uninstalling Aria Links…"
echo "This removes the aria-links tool, its tap, and your saved"
echo "config (including your API key). Homebrew and Node stay —"
echo "other tools may need them."

if command -v brew >/dev/null 2>&1; then
  if brew list --formula aria-links >/dev/null 2>&1 </dev/null; then
    brew uninstall aria-links </dev/null || brew uninstall techytonys/tap/aria-links </dev/null || true
  else
    echo "aria-links isn't installed via Homebrew — nothing to remove there."
  fi
  if brew tap | grep -qx "techytonys/tap" </dev/null; then
    brew untap techytonys/tap </dev/null || true
  fi
else
  echo "Homebrew isn't available in this shell, so there's no"
  echo "Homebrew install of aria-links to remove."
fi

CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/aria-links"
if [ -d "${CONFIG_DIR}" ]; then
  rm -rf "${CONFIG_DIR}"
  echo "Removed your saved config (${CONFIG_DIR}) — your API key is gone from this machine."
else
  echo "No saved config found at ${CONFIG_DIR}."
fi

if [ -n "${ARIA_LINKS_API_KEY:-}" ]; then
  echo "Heads-up: this shell has ARIA_LINKS_API_KEY set. If you added"
  echo "it to your shell profile (~/.zshrc or ~/.bashrc), remove that"
  echo "line too — this script doesn't edit your profiles."
fi

FAILED=0
if command -v aria-links >/dev/null 2>&1; then
  echo "aria-links is still on your PATH — the uninstall didn't fully take."
  FAILED=1
fi
if [ -d "${CONFIG_DIR}" ]; then
  echo "Your config folder is still there: ${CONFIG_DIR}"
  FAILED=1
fi
if [ "${FAILED}" -ne 0 ]; then
  echo "Run this uninstaller one more time; if it still fails, remove"
  echo "the pieces above by hand."
  exit 1
fi

echo ""
echo "✓ Aria Links is uninstalled."
