#!/usr/bin/env bash
#
# Local installer for this Ghostty config.
#
# Installs the config, custom icon, and cursor-trail shader from this repo
# (the files sitting next to this script) into Ghostty's config directory.
# Use this instead of install.sh when you have the repo checked out locally
# and want to install your working copy.
#
#   ./install-local.sh
#
set -euo pipefail

# Directory this script lives in, so it works from any cwd.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SRC_CONFIG="$SCRIPT_DIR/config.ghostty"
SRC_ICON="$SCRIPT_DIR/icons/ghostty-light.icns"
SRC_SHADER="$SCRIPT_DIR/shaders/cursor_smear.glsl"

ICON_NAME="Ghostty.icns"
SHADER_NAME="cursor_smear.glsl"

# Ghostty reads its config from $XDG_CONFIG_HOME/ghostty/config
# (defaults to ~/.config/ghostty/config).
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
CONFIG_FILE="$CONFIG_DIR/config"
ICON_FILE="$CONFIG_DIR/$ICON_NAME"
SHADER_DIR="$CONFIG_DIR/shaders"
SHADER_FILE="$SHADER_DIR/$SHADER_NAME"

# --- pretty output --------------------------------------------------------
bold() { printf '\033[1m%s\033[0m\n' "$1"; }
info() { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
ok()   { printf '\033[1;32m==>\033[0m %s\n' "$1"; }
err()  { printf '\033[1;31mError:\033[0m %s\n' "$1" >&2; }

bold "Ghostty config installer (local)"
info "Source: $SCRIPT_DIR"
info "Target: $CONFIG_DIR"

# --- prerequisites: source files must exist -------------------------------
for f in "$SRC_CONFIG" "$SRC_ICON" "$SRC_SHADER"; do
  if [ ! -f "$f" ]; then
    err "Missing source file: $f"
    exit 1
  fi
done

# --- create config dirs ---------------------------------------------------
mkdir -p "$CONFIG_DIR" "$SHADER_DIR"

# --- install files --------------------------------------------------------
cp "$SRC_CONFIG" "$CONFIG_FILE"
ok "Installed config to $CONFIG_FILE"

cp "$SRC_ICON" "$ICON_FILE"
ok "Installed icon to $ICON_FILE"

cp "$SRC_SHADER" "$SHADER_FILE"
ok "Installed shader to $SHADER_FILE"

# --- next steps -----------------------------------------------------------
echo
bold "Done!"
echo "  • Reload in Ghostty with Cmd+Shift+, (or restart it)."
echo "  • The config uses the 'JetBrainsMono Nerd Font'. Install it with:"
echo "      brew install --cask font-jetbrains-mono-nerd-font"
