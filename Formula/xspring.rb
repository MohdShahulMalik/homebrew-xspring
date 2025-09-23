class Xspring < Formula
  desc "A tool to scaffold spring boot projects interactively like the vs code extension for scaffolding a spring boot project"
  homepage "https://github.com/MohdShahulMalik/xspring"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.1/xspring-aarch64-apple-darwin.tar.xz"
      sha256 "953ae1973cda8c85d4702de6249c2d8b55f7eb427fc770405df984d79336e534"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.1/xspring-x86_64-apple-darwin.tar.xz"
      sha256 "c5be912ac7e9fb5763287431189d47217049e35919799cd6356b8222535419df"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.1/xspring-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f5b997b823ac36a6e82a7e07cdb86778db7b6eb3df0c3041a43521a7c4567942"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.1/xspring-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf9b72d28d371592aaddc6dbe9b12decbdc8d5ac32bab0f45abe2a1b6132e7a3"
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
    bin.install "xspring" if OS.mac? && Hardware::CPU.arm?
    bin.install "xspring" if OS.mac? && Hardware::CPU.intel?
    bin.install "xspring" if OS.linux? && Hardware::CPU.arm?
    bin.install "xspring" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
