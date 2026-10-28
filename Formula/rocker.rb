class Rocker < Formula
  desc "Rocker: a native desktop client for the Docker Engine API."
  homepage "https://github.com/makis-san/rocker"
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.5/rocker-aarch64-apple-darwin.tar.xz"
      sha256 "702202c754d261b24d676f159d7d89b8f55daa357a8a8c0a40a7f94eed3ab3f2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.5/rocker-x86_64-apple-darwin.tar.xz"
      sha256 "e8347b1bebf9e081b88348d4d55b2a7497a35c573a9caf42411264dbd2cd6a68"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.5/rocker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d94cb264e38ab75805f261800a397aed137012edbfd777d65b00dc207e42720b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.5/rocker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2863b062ad2da93231721acb4ffa7d76a1fb727ee71c2af07650fa7d3070d7bc"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
