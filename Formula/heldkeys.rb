class Heldkeys < Formula
  desc "Which credentials could a hijacked AI agent use from here? Read-only, never prints a secret."
  homepage "https://github.com/hugomn/heldkeys"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.3/heldkeys-aarch64-apple-darwin.tar.xz"
      sha256 "7f24b3637ad89630a0d26d3ea8afedb0b4c64dc05aa445e55369e1482a0c2ce9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.3/heldkeys-x86_64-apple-darwin.tar.xz"
      sha256 "2cc3553c6e75319b7dac9fd69c9c4b12f8b0df4eb78a91bc8dc81d9e68ae29fe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.3/heldkeys-aarch64-unknown-linux-musl.tar.xz"
      sha256 "884fe9f96b23d49c8b7c73123f1a53624f43334f933d7475de4dd7db6e92d436"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.3/heldkeys-x86_64-unknown-linux-musl.tar.xz"
      sha256 "3d6d36562380e473440f1d129a8aa0de81a543a07a41c3ee52917fef0a24074b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
      bin.install "heldkeys"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "heldkeys"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "heldkeys"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "heldkeys"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/heldkeys --version")
  end
end
