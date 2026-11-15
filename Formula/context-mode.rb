require "language/node"

class ContextMode < Formula
  desc "MCP server for local context-window optimization"
  homepage "https://github.com/mksglu/context-mode"
  url "https://registry.npmjs.org/context-mode/-/context-mode-2.2.0.tgz"
  sha256 "1230c57281a9d9236f0ea01450839af73263910b1dd097e605fa34cf712506b2"
  license "Elastic-2.0"

  # Tap-only until upstream provides a Homebrew formula.

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Diagnostics complete", shell_output("#{bin}/context-mode doctor")
  end
end
