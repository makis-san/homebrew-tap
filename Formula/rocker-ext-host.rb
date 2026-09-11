class RockerExtHost < Formula
  desc "Supervised extension host: rhai and wasmtime runtimes, capability gate."
  homepage "https://github.com/makis-san/rocker"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.0/rocker-ext-host-aarch64-apple-darwin.tar.xz"
      sha256 "4921ecd3c78753164e40c75b8d90f35186dd33e30c279746fe05fe008fa3f1db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.0/rocker-ext-host-x86_64-apple-darwin.tar.xz"
      sha256 "2ffeaf79b84bf9112da7080c36f01ccb241313083ade983f5ef7b3e57a1be924"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.0/rocker-ext-host-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fd58de68e5ff61a7cfc94245462a6571df6cea5306b6d2561c89c7276d704a68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.2.0/rocker-ext-host-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4f810927b2ba7993984c107c38660c09570ac2d87f0513a5e3308a2b0ea4dafb"
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
      bin.install "rocker-ext-host"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rocker-ext-host"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rocker-ext-host"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rocker-ext-host"
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
