class Xspring < Formula
  desc "A tool to scaffold spring boot projects interactively like the vs code extension for scaffolding a spring boot project"
  homepage "https://github.com/MohdShahulMalik/xspring"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.3/xspring-aarch64-apple-darwin.tar.xz"
      sha256 "c83bfbacbf74aae2e105a058f6637014e4ae8929717bc1a83c0cbfafc027bb80"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.3/xspring-x86_64-apple-darwin.tar.xz"
      sha256 "4d2ff76f8dfd55e96c0f0f92c4dd513e58df8445e77b6138190edbf4a2536ed5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.3/xspring-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e2f246d66e672c7e1e4d7d2c02ccb27800daac2bb7e22c88b8012d9b08c07514"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.3/xspring-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d4a1925f43943244def301ce556a0156313410de27ce24ccd1cbbca8c01d4b5a"
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
