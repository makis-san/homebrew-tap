class Rocker < Formula
  desc "Rocker: a native desktop client for the Docker Engine API."
  homepage "https://github.com/makis-san/rocker"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.1/rocker-aarch64-apple-darwin.tar.xz"
      sha256 "485f26bad144d2ed310c6f1a82e6578253cb5a3feac5c42d0e1ad15ed2948b2b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.1/rocker-x86_64-apple-darwin.tar.xz"
      sha256 "5a3bd99405aa0504340dbe29197c1098b80b0c782aa64e63abe6e4fa1007c0c7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.1/rocker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d72a2b2b0474e5636b2aad06001aebd74389f4f905af2a03acb47da451979c9b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.1/rocker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "916a2084ca1ced126a6f2562b483a4e5d8d40da09d8979a4011deb33faaecddb"
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
      bin.install "rocker", "rocker-ext-host"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rocker", "rocker-ext-host"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rocker", "rocker-ext-host"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rocker", "rocker-ext-host"
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
