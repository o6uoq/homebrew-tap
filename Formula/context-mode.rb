require "language/node"

class ContextMode < Formula
  desc "MCP server for local context-window optimization"
  homepage "https://github.com/mksglu/context-mode"
  url "https://registry.npmjs.org/context-mode/-/context-mode-2.1.0.tgz"
  sha256 "fcb73de1f4e3a418d5a5faf84a7f9f637e4ac547baa7bd51953339259dee398c"
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
