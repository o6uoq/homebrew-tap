require "language/node"

class Paperclip < Formula
  desc "Open-source orchestration for zero-human companies"
  homepage "https://github.com/paperclipai/paperclip"
  url "https://registry.npmjs.org/paperclipai/-/paperclipai-2026.525.0.tgz"
  sha256 "d53b76492d98d6976e60ecfd548dcb8cde49e9aa425dfe26913d90d99b7be060"
  license "MIT"

  # Tap-only until upstream provides a Homebrew formula.

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paperclipai --version")
  end
end
