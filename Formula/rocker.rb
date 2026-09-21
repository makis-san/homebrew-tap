class Rocker < Formula
  desc "Rocker: a native desktop client for the Docker Engine API."
  homepage "https://github.com/makis-san/rocker"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.1/rocker-aarch64-apple-darwin.tar.xz"
      sha256 "a5528f062f4dee27eda3f93f5f580ec7a2753a05da1b530630a53fbc66758e45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.1/rocker-x86_64-apple-darwin.tar.xz"
      sha256 "f926ee2a10828e2cc96fc35d791aa0bdd021e64cf7ac3c3361bec7be793d10aa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.1/rocker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7e702e0772c5f0b310cc8c2ae961ef35ef16320d93d477a4aa0d6b470bc43e1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/makis-san/rocker/releases/download/v0.3.1/rocker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1998ab30183994adc1d4507e9ebabd92c1b3a9fdef50286c3f9ab91f92f1122c"
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
