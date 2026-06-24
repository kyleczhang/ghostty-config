#!/usr/bin/env bash
#
# One-line installer for this Ghostty config.
#
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/kyleczhang/ghostty-config/main/install.sh)"
#
# It downloads config.ghostty into Ghostty's config directory, backing up any
# existing config first.

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/kyleczhang/ghostty-config/main"
SRC_NAME="config.ghostty"

# Ghostty reads its config from $XDG_CONFIG_HOME/ghostty/config
# (defaults to ~/.config/ghostty/config).
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
CONFIG_FILE="$CONFIG_DIR/config"

# --- pretty output --------------------------------------------------------
bold() { printf '\033[1m%s\033[0m\n' "$1"; }
info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
ok()   { printf '\033[1;32m==>\033[0m %s\n' "$1"; }
err()  { printf '\033[1;31mError:\033[0m %s\n' "$1" >&2; }

# --- prerequisites --------------------------------------------------------
if ! command -v curl >/dev/null 2>&1; then
  err "curl is required but not found."
  exit 1
fi

bold "Ghostty config installer"
info "Target: $CONFIG_FILE"

# --- create config dir ----------------------------------------------------
mkdir -p "$CONFIG_DIR"

# --- download into a temp file, then move into place ----------------------
TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

info "Downloading $SRC_NAME ..."
if ! curl -fsSL "$REPO_RAW/$SRC_NAME" -o "$TMP_FILE"; then
  err "Download failed from $REPO_RAW/$SRC_NAME"
  exit 1
fi

# Sanity check: file is non-empty.
if [ ! -s "$TMP_FILE" ]; then
  err "Downloaded file is empty."
  exit 1
fi

mv "$TMP_FILE" "$CONFIG_FILE"
trap - EXIT

ok "Installed config to $CONFIG_FILE"

# --- next steps -----------------------------------------------------------
echo
bold "Done!"
echo "  • Reload in Ghostty with Cmd+Shift+, (or restart it)."
echo "  • The config uses the 'JetBrainsMono Nerd Font'. Install it with:"
echo "      brew install --cask font-jetbrains-mono-nerd-font"
