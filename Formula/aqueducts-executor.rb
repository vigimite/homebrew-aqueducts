class AqueductsExecutor < Formula
  desc "Remote executor for the Aqueducts data pipeline framework"
  homepage "https://github.com/vigimite/aqueducts"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.0/aqueducts-executor-aarch64-apple-darwin.tar.xz"
      sha256 "7f78f737036454ebf160eb29164949a07657c57f71b0b48aaf51467599e37247"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.0/aqueducts-executor-x86_64-apple-darwin.tar.xz"
      sha256 "4e6ca277b9c6c1e27a00283f230f91363f84be6e6e34b1c627dedbfad1453a8a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.0/aqueducts-executor-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ea2760ca2e1903b360119c9afee4f23b75e4ac7de7c0a13827f3c928d652952"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.0/aqueducts-executor-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "79fcdbca03c4605b081338932526baa5cf02f7406af842bc1bb1125cdcd6c759"
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
