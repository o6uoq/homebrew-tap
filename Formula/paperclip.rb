require "language/node"

class Paperclip < Formula
  desc "Open-source orchestration for zero-human companies"
  homepage "https://github.com/paperclipai/paperclip"
  url "https://registry.npmjs.org/paperclipai/-/paperclipai-2026.403.0.tgz"
  sha256 "63a83aa9b72e2dffa6aba39e88d33abfa3971310e6985c121723a505e7808957"
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
