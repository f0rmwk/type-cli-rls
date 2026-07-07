#!/usr/bin/env sh
set -eu

REPO="${TYPE_CLI_REPO:-f0rmwk/type-cli-releases}"
VERSION="${TYPE_CLI_VERSION:-latest}"
INSTALL_DIR="${TYPE_CLI_INSTALL_DIR:-${HOME}/.local/bin}"
TMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t type-cli)"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM

need() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "error: required command not found: $1" >&2
    exit 1
  fi
}

need uname
need tar

if command -v curl >/dev/null 2>&1; then
  fetch() { curl -fsSL "$1" -o "$2"; }
elif command -v wget >/dev/null 2>&1; then
  fetch() { wget -qO "$2" "$1"; }
else
  echo "error: curl or wget is required" >&2
  exit 1
fi

os="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m | tr '[:upper:]' '[:lower:]')"

case "$os" in
  darwin) os="macos" ;;
  linux) os="linux" ;;
  *) echo "error: unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

case "$arch" in
  arm64|aarch64) arch="arm64" ;;
  x86_64|amd64) arch="x64" ;;
  *) echo "error: unsupported CPU: $(uname -m)" >&2; exit 1 ;;
esac

asset="type-cli-${os}-${arch}.tar.gz"
if [ "$VERSION" = "latest" ]; then
  url="https://github.com/${REPO}/releases/latest/download/${asset}"
else
  url="https://github.com/${REPO}/releases/download/${VERSION}/${asset}"
fi

mkdir -p "$INSTALL_DIR"
echo "Downloading ${asset} from ${REPO} (${VERSION})..."
fetch "$url" "$TMP_DIR/$asset"
tar -xzf "$TMP_DIR/$asset" -C "$TMP_DIR"
install -m 0755 "$TMP_DIR/type-cli" "$INSTALL_DIR/type-cli"

echo "Installed type-cli to $INSTALL_DIR/type-cli"
case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *) echo "Note: $INSTALL_DIR is not on your PATH." ;;
esac
