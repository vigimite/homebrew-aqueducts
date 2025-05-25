class AqueductsCli < Formula
  desc "CLI application to run pipelines defined for the aqueducts framework"
  homepage "https://github.com/vigimite/aqueducts"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.0/aqueducts-cli-aarch64-apple-darwin.tar.xz"
      sha256 "35f45b9dff74cd057b598b7ac384c4976ada2345e2ec63218f0c595c3eb25602"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.0/aqueducts-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bb3055aad8cde6fb52f866f0e9feb0eb5aee2b36d9fb3d40753245fd151e2a23"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.0/aqueducts-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "35134635748cb04fc85f5992633b9aace8cda7f6925c19ba75f4602a709db7f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vigimite/aqueducts/releases/download/v0.10.0/aqueducts-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "eeae682241cf12186935312e206bb29fda5118e01f85d6524ec0a7ea4e7cae6d"
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
