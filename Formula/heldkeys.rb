class Heldkeys < Formula
  desc "Which credentials could a hijacked AI agent use from here? Read-only, never prints a secret."
  homepage "https://github.com/hugomn/heldkeys"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.2/heldkeys-aarch64-apple-darwin.tar.xz"
      sha256 "99910cc5caf0c6a779ff8f0dab0b74f49d0d82ae7d056b02a4edcc095d24b542"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.2/heldkeys-x86_64-apple-darwin.tar.xz"
      sha256 "37b4c7a745928a6139d6ee959c4b9759e7bb53964bcf8385fe03adc55ec69be0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.2/heldkeys-aarch64-unknown-linux-musl.tar.xz"
      sha256 "39b787f93597e58a3f8729be42fd42d033b37c2bef02a850b0364bbfb19d642c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hugomn/heldkeys/releases/download/v0.2.2/heldkeys-x86_64-unknown-linux-musl.tar.xz"
      sha256 "e2dbc6655a8aff95df1e1647882f43a41e4c7329482f5ee9a0292d40e62f92b1"
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
