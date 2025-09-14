class Xspring < Formula
  desc "A tool to scaffold spring boot projects interactively like the vs code extension for scaffolding a spring boot project"
  homepage "https://github.com/MohdShahulMalik/xspring"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.0/xspring-aarch64-apple-darwin.tar.xz"
      sha256 "bf7b41d1647dab099e63a2f3307130bdea08062b57f03207fe431070913055d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.0/xspring-x86_64-apple-darwin.tar.xz"
      sha256 "097e635675ca3854092a513f6de00246787053f61facff195d0fc93a3ca8d9bb"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.0/xspring-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "613f2a819176236c4c45dc7d90bd84037fef8f17ad1c1bf52285603fdbd9089b"
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
