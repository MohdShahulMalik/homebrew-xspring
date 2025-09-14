class Xspring < Formula
  desc "A tool to scaffold spring boot projects interactively like the vs code extension for scaffolding a spring boot project"
  homepage "https://github.com/MohdShahulMalik/xspring"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.0/xspring-aarch64-apple-darwin.tar.xz"
      sha256 "f4d44b7002a980275423dd6e95697c0c8194842be13b38d52a11e23490fe981f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.0/xspring-x86_64-apple-darwin.tar.xz"
      sha256 "77bfc589ff8d9d7f7e1235c51bc88131ec66f96a0dbe99b3c2685dec7d26145f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.0/xspring-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1d4c8f9083dad1c6f0ef37091f32c913c4b2ad3572d2be8cef1de1c7588a8d8f"
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "xspring" if OS.mac? && Hardware::CPU.arm?
    bin.install "xspring" if OS.mac? && Hardware::CPU.intel?
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
