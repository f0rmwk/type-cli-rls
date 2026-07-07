class TypeCli < Formula
  desc "Terminal typing game"
  homepage "https://github.com/f0rmwk/type-cli-releases"
  version "1.0.0"
  license "PolyForm-Noncommercial-1.0.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/f0rmwk/type-cli-releases/releases/download/v1.0.0/type-cli-macos-arm64.tar.gz"
      sha256 "98efdf84df34ada595d491af0dddb899a171d23d9cbde5a0d90b2112a6b270a4"
    else
      url "https://github.com/f0rmwk/type-cli-releases/releases/download/v1.0.0/type-cli-macos-x64.tar.gz"
      sha256 "efae7fc5668299db2d677090534ff6006ff5622df38eb7f0557bd41cbcee6f06"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/f0rmwk/type-cli-releases/releases/download/v1.0.0/type-cli-linux-x64.tar.gz"
      sha256 "9500e16caa03cc8c848bb33eefc8d7febe50851ba27742b1887fe0114221ca28"
    end
  end

  def install
    bin.install "type-cli"
  end

  test do
    assert_match "type 1.0.0", shell_output("#{bin}/type-cli --version")
  end
end
