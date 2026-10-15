class Heldkeys < Formula
  desc "Which credentials could a hijacked AI agent use from here? Read-only, never prints a secret."
  homepage "https://github.com/hugomn/heldkeys"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.1.1/heldkeys-aarch64-apple-darwin.tar.xz"
      sha256 "fdf797ae51866127884ebf27cd6eaf32238b7235771c915a32914b7a93b3df64"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.1.1/heldkeys-x86_64-apple-darwin.tar.xz"
      sha256 "6d519d727a8b8aab2e4afb645556c747cc7b648de3c4ac951e65d545b348ba2f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.1.1/heldkeys-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7a61c6fb23deba616f7bb040740141446dc238c95e289b79bb0bb00c1a707420"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.1.1/heldkeys-x86_64-unknown-linux-musl.tar.xz"
      sha256 "3fb1971cef15890b936196889d0216f4e1cd3eb492baeacbb635cdb40c63fd5b"
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
end
