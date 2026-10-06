class ThunderDaw < Formula
  desc "A small FL Studio-style DAW in Rust"
  homepage "https://canureal.github.io/thunder-daw/"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/canureal/thunder-daw/releases/download/v0.2.3/thunder-daw-aarch64-apple-darwin.tar.xz"
      sha256 "a266813046161d185279cd0225d62bb468523f6492a68677c7c01acbe3ce0f57"
    end
    if Hardware::CPU.intel?
      url "https://github.com/canureal/thunder-daw/releases/download/v0.2.3/thunder-daw-x86_64-apple-darwin.tar.xz"
      sha256 "0107598d8e716a70e29b463d271ad500c5e96ac1a5faa4bb5ae7a3d28e0184b5"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/canureal/thunder-daw/releases/download/v0.2.3/thunder-daw-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "bf30b22cbaae9dd00d59c27a6351835a9042acad0ec5b2edf258e309e1e0193a"
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
