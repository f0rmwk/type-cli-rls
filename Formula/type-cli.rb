class TypeCli < Formula
  desc "Terminal typing game"
  homepage "https://github.com/f0rmwk/type-cli-rls"
  version "1.0.1"
  license "PolyForm-Noncommercial-1.0.0"

  depends_on "ca-certificates"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/f0rmwk/type-cli-rls/releases/download/v1.0.1/type-cli-macos-arm64.tar.gz"
      sha256 "b8c7c040cd998c7d94fba2514a256ee202353297d449ba2d9d965cf48a2aa946"
    else
      url "https://github.com/f0rmwk/type-cli-rls/releases/download/v1.0.1/type-cli-macos-x64.tar.gz"
      sha256 "df4848a27756e48f165fa334d764a501fd13744e54e554cb9d9baac34e41060b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/f0rmwk/type-cli-rls/releases/download/v1.0.1/type-cli-linux-x64.tar.gz"
      sha256 "6654183f6792d6d839db9ece0fc18a1cab0e0cb08888eb29abcf7356f893937d"
    end
  end

  def install
    bin.install "type-cli"
  end

  test do
    assert_match "type 1.0.1", shell_output("#{bin}/type-cli --version")
  end
end
