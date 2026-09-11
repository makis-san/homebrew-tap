class Rocker < Formula
  desc "Rocker: a native desktop client for the Docker Engine API."
  homepage "https://github.com/makis-san/rocker"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.0/rocker-aarch64-apple-darwin.tar.xz"
      sha256 "bcd6d64fb4455766a300278676711b8af589ffca1c10cdec6a2ac830f57a5fb4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.0/rocker-x86_64-apple-darwin.tar.xz"
      sha256 "194b94067f4b13cd2edb2d6f3afe4dfda4fd8d971d06a6b8bea38a989eb6f97f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.0/rocker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6a0fa57d0b4b057b4b568fcc7a5b468fea073eb9d763656caf09bc0e9ab3bccb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.0/rocker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5b5077169f9b7c11c8f39c655655bd7bfb63377ed7af2236691011db04208de8"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
      bin.install "rocker"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rocker"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rocker"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rocker"
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
