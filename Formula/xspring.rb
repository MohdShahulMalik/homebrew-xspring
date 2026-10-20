class Xspring < Formula
  desc "Interactive CLI to scaffold Spring Boot projects and add dependencies to existing ones — the terminal companion to start.spring.io"
  homepage "https://github.com/MohdShahulMalik/xspring"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.2.0/xspring-aarch64-apple-darwin.tar.xz"
      sha256 "2246cebb6335bdba127d50b9d0dae5031f1a7d8ebec35da0ccdda8a47bc42dd9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.2.0/xspring-x86_64-apple-darwin.tar.xz"
      sha256 "4107f22ef18dbd19d1019925dbfaa20719d0dcb173ad77a864431baabb9eefae"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.2.0/xspring-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1170289e6f0ce4f9b025775c9d1da0e807aa8f8f1832d548c1f8258e77668873"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.2.0/xspring-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "03906e2e6f6d96d1233fdadb2afcf06e75ecc985046d5a42601aee8ee353f975"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
      bin.install "xspring"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "xspring"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "xspring"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "xspring"
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
