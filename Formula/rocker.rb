class Rocker < Formula
  desc "Rocker: a native desktop client for the Docker Engine API."
  homepage "https://github.com/makis-san/rocker"
  version "0.1.2"
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.1.2/rocker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "369fb9dfb90916e7f8bf0f2ae85008468c6eeb81544b072980761010890d73c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.1.2/rocker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7bf4738b050a64b68c94484550a1fd87c63a119d8e3c0216f211a77ba11a09fa"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-unknown-linux-gnu": {},
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
