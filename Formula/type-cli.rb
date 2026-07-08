class TypeCli < Formula
  desc "Terminal typing game"
  homepage "https://github.com/f0rmwk/type-cli-rls"
  version "1.0.2"
  license "PolyForm-Noncommercial-1.0.0"

  depends_on "ca-certificates"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/f0rmwk/type-cli-rls/releases/download/v1.0.2/type-cli-macos-arm64.tar.gz"
      sha256 "dfb8e2ce41cff05e74e35069323e9f12a2032164b91b9e5c89fedf554d0ce1e3"
    else
      url "https://github.com/f0rmwk/type-cli-rls/releases/download/v1.0.2/type-cli-macos-x64.tar.gz"
      sha256 "39d260589c5d86ac6c2c1bb4a020bc4d6f14382ed2d4374a97136f90610d7d8d"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/f0rmwk/type-cli-rls/releases/download/v1.0.2/type-cli-linux-x64.tar.gz"
      sha256 "61b3ea49aa9ddb4b75a72c06db1f140dfcb852876439c5189eb38581720e073e"
    end
  end

  def install
    bin.install "type-cli"
  end

  test do
    assert_match "type 1.0.2", shell_output("#{bin}/type-cli --version")
  end
end
