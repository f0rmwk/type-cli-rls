# type-cli releases

Public standalone binary releases for `type-cli`, a terminal typing game.

The source repository is private. These downloads are provided under the
PolyForm Noncommercial License 1.0.0. Commercial use requires permission.

## Install: macOS/Linux

```bash
curl -fsSL https://raw.githubusercontent.com/f0rmwk/type-cli-rls/main/install.sh | sh
```

Then run:

```bash
type-cli
```

If `~/.local/bin` is not on your `PATH`, add it or set another install dir:

```bash
TYPE_CLI_INSTALL_DIR=/usr/local/bin sh install.sh
```

## Install: Homebrew

```bash
brew tap f0rmwk/type-cli-rls https://github.com/f0rmwk/type-cli-rls
brew install type-cli
```

## Windows

Download `type-cli-windows-x64.zip` from the latest release, unzip it, and run
`type-cli.exe`.

Scoop users can use the manifest in `bucket/type-cli.json` once this repo is
added as a bucket.

## Checksums

Checksums are published in `checksums/<version>/SHA256SUMS` and attached to each
GitHub release.

## License

PolyForm Noncommercial License 1.0.0. See `LICENSE` and `NOTICE`.
