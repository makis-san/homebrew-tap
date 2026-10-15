class Rocker < Formula
  desc "Rocker: a native desktop client for the Docker Engine API."
  homepage "https://github.com/makis-san/rocker"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.4/rocker-aarch64-apple-darwin.tar.xz"
      sha256 "62b542d9dd47e4c022092f5af022dbb56baf3d67865a73cca440d509e93df292"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.4/rocker-x86_64-apple-darwin.tar.xz"
      sha256 "f57526b286cf005c4ed57945c6580f025dcaf02b81af5e9c9eae1af346267d7c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.4/rocker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6874dd7d4f2b4826fa018b78ed9ccac27a159ac197cc36f3fd7e1d4d59779ed0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.4/rocker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ef0f587984c9dc040efdd1c678136a5ee0676591790205395898f4d38aaa470f"
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
