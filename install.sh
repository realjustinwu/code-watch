#!/usr/bin/env sh
# cw (CodeWatch) installer
# Usage:
#   Install:   curl -fsSL https://raw.githubusercontent.com/realjustinwu/code-watch/main/install.sh | sh
#   Uninstall: curl -fsSL https://raw.githubusercontent.com/realjustinwu/code-watch/main/install.sh | sh -s -- --uninstall

set -e

REPO="realjustinwu/code-watch"
BINARY_NAME="cw"
INSTALL_DIR="${CW_INSTALL_DIR:-$HOME/.local/bin}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { printf "${GREEN}[INFO]${NC} %s\n" "$1"; }
warn()  { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }
error() { printf "${RED}[ERROR]${NC} %s\n" "$1"; exit 1; }

# --- Uninstall ---
uninstall() {
    info "Uninstalling $BINARY_NAME..."

    # Remove binary
    TARGET="${INSTALL_DIR}/${BINARY_NAME}"
    if [ -f "$TARGET" ]; then
        rm -f "$TARGET"
        info "Removed $TARGET"
    else
        warn "$TARGET not found (already removed?)"
    fi

    # Remove shell aliases
    SHELL_RC=""
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_RC="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_RC="$HOME/.bashrc"
    fi

    if [ -n "$SHELL_RC" ] && grep -q '# >>> cw aliases >>>' "$SHELL_RC" 2>/dev/null; then
        # Delete the alias block
        sed -i.bak '/# >>> cw aliases >>>/,/# <<< cw aliases <<</d' "$SHELL_RC"
        rm -f "${SHELL_RC}.bak"
        info "Removed shell aliases from $SHELL_RC"
        warn "Run 'source $SHELL_RC' or restart your terminal to apply"
    fi

    info "Done! cw has been uninstalled."
    exit 0
}

# Parse flags
case "${1:-}" in
    --uninstall|-u) uninstall ;;
esac

# --- Install ---

# Check if already installed
if command -v "$BINARY_NAME" >/dev/null 2>&1; then
    VERSION=$("$BINARY_NAME" --version 2>/dev/null || echo "unknown")
    info "$BINARY_NAME already installed: $VERSION ($(which $BINARY_NAME))"
    info "Reinstalling..."
fi

info "Installing $BINARY_NAME..."

# Detect OS
OS=$(uname -s)
ARCH=$(uname -m)

case "$OS" in
    Darwin) info "macOS $ARCH" ;;
    Linux)  info "Linux $ARCH" ;;
    *)      error "Unsupported OS: $OS" ;;
esac

# Create install dir
mkdir -p "$INSTALL_DIR"

# Download single-file binary
TARGET="${INSTALL_DIR}/${BINARY_NAME}"
REMOTE="https://raw.githubusercontent.com/${REPO}/main/cw"

info "Downloading $REMOTE"
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REMOTE" -o "$TARGET"
elif command -v wget >/dev/null 2>&1; then
    wget -q "$REMOTE" -O "$TARGET"
else
    error "Neither curl nor wget found"
fi

chmod +x "$TARGET"

# Verify
if "$TARGET" --version >/dev/null 2>&1; then
    info "Installed: $($TARGET --version) → $TARGET"
else
    error "Installation failed — cw --version returned error"
fi

# PATH check
case ":$PATH:" in
    *":$INSTALL_DIR:"*) ;;
    *)
        warn "$INSTALL_DIR is not in PATH. Add to your shell profile:"
        warn "  echo 'export PATH=\"$INSTALL_DIR:\$PATH\"' >> ~/.zshrc"
        warn "  source ~/.zshrc"
        ;;
esac

echo ""
info "Done! Usage: cw <command> [args...]"
info "Example:    cw codex \"fix the bug\""
info "Aliases:    cw init --aliases   # add shell aliases for codex/claude"
info "Uninstall:  curl -fsSL $REMOTE | sh -s -- --uninstall"
