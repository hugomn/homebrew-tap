class Heldkeys < Formula
  desc "Which credentials could a hijacked AI agent use from here? Read-only, never prints a secret."
  homepage "https://github.com/hugomn/heldkeys"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.1/heldkeys-aarch64-apple-darwin.tar.xz"
      sha256 "4de0ed2127d700cda5907fb827d09a020a1708fbfb65a5bdc54946169c396f2b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.1/heldkeys-x86_64-apple-darwin.tar.xz"
      sha256 "fd28839a799c85820a9524726c98cb0d02a5a0e1667baa6c10d548ef3529b9dc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.1/heldkeys-aarch64-unknown-linux-musl.tar.xz"
      sha256 "76fdcc29a9d4578c2c64693dc4c139e6554ab33fc962f96cb3647afb5e6148aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.1/heldkeys-x86_64-unknown-linux-musl.tar.xz"
      sha256 "0aeb71f11fdb400c557d83df1a22fc688e9819af1e6b8e93babb827a0bec3f84"
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
