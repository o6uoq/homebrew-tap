require "language/node"

class Paperclip < Formula
  desc "Open-source orchestration for zero-human companies"
  homepage "https://github.com/paperclipai/paperclip"
  url "https://registry.npmjs.org/paperclipai/-/paperclipai-2026.517.0.tgz"
  sha256 "e82697e26b85c05ae94ed5cc8e64221808ce72b043f5222570af83d3bc588d71"
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
