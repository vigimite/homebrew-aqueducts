class AqueductsCli < Formula
  desc "CLI application to run pipelines defined for the aqueducts framework"
  homepage "https://github.com/vigimite/aqueducts"
  version "0.10.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.1/aqueducts-cli-aarch64-apple-darwin.tar.xz"
      sha256 "282e08bd32c54efa1fefc1277c1a769768a6145ec7f33b3c95db397fd8ad3893"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.1/aqueducts-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6262e55bc616875b30b557036c370bbe767bf4e9dc372d35828ac6e754518592"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.1/aqueducts-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c18e58e7a2505df4be3f6b7cd6f15280d5d1e4944f261e9148d66822525c912d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.1/aqueducts-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3b62b3bff8686869e177b81dd6dfe5de43413f3ca4761ef8e4cd68f91361b387"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
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
    bin.install "aqueducts" if OS.mac? && Hardware::CPU.arm?
    bin.install "aqueducts" if OS.mac? && Hardware::CPU.intel?
    bin.install "aqueducts" if OS.linux? && Hardware::CPU.arm?
    bin.install "aqueducts" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
