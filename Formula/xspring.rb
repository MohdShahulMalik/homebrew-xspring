class Xspring < Formula
  desc "A tool to scaffold spring boot projects interactively like the vs code extension for scaffolding a spring boot project"
  homepage "https://github.com/MohdShahulMalik/xspring"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.2/xspring-aarch64-apple-darwin.tar.xz"
      sha256 "7ce82c22e9d1d51a97d07fa4c0bce3d7b6756d8737667f7ef25c03f99687274a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.2/xspring-x86_64-apple-darwin.tar.xz"
      sha256 "681c3db971d1ee59e6be9f202f61c425b4331efc1598026bbb68190335274fd0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.2/xspring-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "31fd2038e4e9167ef312f26f4724a64dfb4da931ca75edadbdf77e12669c6248"
    end
    if Hardware::CPU.intel?
      url "https://github.com/MohdShahulMalik/xspring/releases/download/v0.1.2/xspring-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "20b4f5782474e81521b96e3e7f1f4db6122373e58954cee95f7c1779ff25f87d"
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
