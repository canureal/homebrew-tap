class ThunderDaw < Formula
  desc "A small FL Studio-style DAW in Rust"
  homepage "https://canureal.github.io/thunder-daw/"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/canureal/thunder-daw/releases/download/v0.2.2/thunder-daw-aarch64-apple-darwin.tar.xz"
      sha256 "6ad833e142434cf1330e546851be5486f55b592907c1c773a636937871d6462a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/canureal/thunder-daw/releases/download/v0.2.2/thunder-daw-x86_64-apple-darwin.tar.xz"
      sha256 "6f210964f616e2246791a685daea11dda2a544257d61aae84be9b70ba048f5ab"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/canureal/thunder-daw/releases/download/v0.2.2/thunder-daw-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0efac59aaccebd26d323c43cf145a4a0d96f9e941f4ba476135e7fc4fdc3d266"
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
