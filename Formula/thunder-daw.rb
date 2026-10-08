class ThunderDaw < Formula
  desc "A small FL Studio-style DAW in Rust"
  homepage "https://canureal.github.io/thunder-daw/"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/canureal/thunder-daw/releases/download/v0.2.4/thunder-daw-aarch64-apple-darwin.tar.xz"
      sha256 "a3ffaee75559043a6635d544c64fbdf80eb1f7586bc46a2c9c42b5bbd543dad7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/canureal/thunder-daw/releases/download/v0.2.4/thunder-daw-x86_64-apple-darwin.tar.xz"
      sha256 "107b966c0a627b7ba1700c0fb93a3d9a0964847c37f177faf8350525f86f6da8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/canureal/thunder-daw/releases/download/v0.2.4/thunder-daw-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "68bd589602a12b58b3a6428d9b30d08eedaeb956d588e1d92fa27781bd1347c2"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "thunder-daw"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "thunder-daw"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "thunder-daw"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
