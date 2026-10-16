class Heldkeys < Formula
  desc "Which credentials could a hijacked AI agent use from here? Read-only, never prints a secret."
  homepage "https://github.com/hugomn/heldkeys"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.0/heldkeys-aarch64-apple-darwin.tar.xz"
      sha256 "cfad35fce41da9396c0002232881d880df530f73b4fc75b8412abe82498a6077"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.0/heldkeys-x86_64-apple-darwin.tar.xz"
      sha256 "fb5027ae790880d2e595d9963dce482b74131b3d8a5415a37734a2cdcaaf0602"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.0/heldkeys-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d5ffb1ea1a562e6e78255c6ffbe40cd990c3802a02f4ed87075113943d0069b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.0/heldkeys-x86_64-unknown-linux-musl.tar.xz"
      sha256 "de90776032ee33265490f0bad6e50e6cf47eb230a5a28c7a96b9555d38f03769"
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
