class AqueductsExecutor < Formula
  desc "Remote executor for the Aqueducts data pipeline framework"
  homepage "https://github.com/vigimite/aqueducts"
  version "0.10.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.1/aqueducts-executor-aarch64-apple-darwin.tar.xz"
      sha256 "39b62c27185834c45b7e270180c1198dd50cc166d1caf4a63c7a608476107a93"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.1/aqueducts-executor-x86_64-apple-darwin.tar.xz"
      sha256 "7ed9639eb0f748635e7145055b5b06e9dd0c785281f7f31990e846c9f8f2af15"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.1/aqueducts-executor-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6002326d3627a84186b76ae28eefe8762fe025c7922943133bae6a064e72142a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.1/aqueducts-executor-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8f35e2323408dca7fcdc4340d009ac2a716469e7abcd940676dc1c48145832f4"
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
    bin.install "aqueducts-executor" if OS.mac? && Hardware::CPU.arm?
    bin.install "aqueducts-executor" if OS.mac? && Hardware::CPU.intel?
    bin.install "aqueducts-executor" if OS.linux? && Hardware::CPU.arm?
    bin.install "aqueducts-executor" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
