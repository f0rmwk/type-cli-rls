#!/usr/bin/env sh
set -eu

REPO="${TYPE_CLI_REPO:-f0rmwk/type-cli-rls}"
VERSION="${TYPE_CLI_VERSION:-latest}"
INSTALL_DIR="${TYPE_CLI_INSTALL_DIR:-${HOME}/.local/bin}"
SKIP_CHECKSUM="${TYPE_CLI_SKIP_CHECKSUM:-0}"
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
need awk

if command -v curl >/dev/null 2>&1; then
  fetch() { curl -fsSL "$1" -o "$2"; }
elif command -v wget >/dev/null 2>&1; then
  fetch() { wget -qO "$2" "$1"; }
else
  echo "error: curl or wget is required" >&2
  exit 1
fi

sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    echo "error: sha256sum or shasum is required for checksum verification" >&2
    exit 1
  fi
}

verify_checksum() {
  asset_path="$1"
  checksum_url="$2"
  checksum_file="$TMP_DIR/SHA256SUMS"
  fetch "$checksum_url" "$checksum_file"
  expected="$(awk -v name="$(basename "$asset_path")" '$2 == name {print $1; exit}' "$checksum_file")"
  if [ -z "$expected" ]; then
    echo "error: checksum for $(basename "$asset_path") not found in SHA256SUMS" >&2
    exit 1
  fi
  actual="$(sha256_file "$asset_path")"
  if [ "$expected" != "$actual" ]; then
    echo "error: checksum verification failed for $(basename "$asset_path")" >&2
    exit 1
  fi
}

validate_tar_archive() {
  archive="$1"
  if ! tar -tzf "$archive" | awk '
    /^\// { bad=1 }
    /(^|\/)\.\.(\/|$)/ { bad=1 }
    END { exit bad }
  '; then
    echo "error: archive contains unsafe paths" >&2
    exit 1
  fi
}

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
  checksum_url="https://github.com/${REPO}/releases/latest/download/SHA256SUMS"
else
  url="https://github.com/${REPO}/releases/download/${VERSION}/${asset}"
  checksum_url="https://github.com/${REPO}/releases/download/${VERSION}/SHA256SUMS"
fi

mkdir -p "$INSTALL_DIR"
echo "Downloading ${asset} from ${REPO} (${VERSION})..."
fetch "$url" "$TMP_DIR/$asset"
if [ "$SKIP_CHECKSUM" = "1" ]; then
  echo "Skipping checksum verification because TYPE_CLI_SKIP_CHECKSUM=1."
else
  echo "Verifying checksum..."
  verify_checksum "$TMP_DIR/$asset" "$checksum_url"
fi
validate_tar_archive "$TMP_DIR/$asset"
tar -xzf "$TMP_DIR/$asset" -C "$TMP_DIR"
[ -f "$TMP_DIR/type-cli" ] || { echo "error: archive did not contain type-cli" >&2; exit 1; }
install -m 0755 "$TMP_DIR/type-cli" "$INSTALL_DIR/type-cli"

echo "Installed type-cli to $INSTALL_DIR/type-cli"
case ":$PATH:" in
  *":$INSTALL_DIR:"*) ;;
  *) echo "Note: $INSTALL_DIR is not on your PATH." ;;
esac
