require "language/node"

class ContextMode < Formula
  desc "MCP server for local context-window optimization"
  homepage "https://github.com/mksglu/context-mode"
  url "https://registry.npmjs.org/context-mode/-/context-mode-2.1.5.tgz"
  sha256 "a866a899a70f7bd5a028e5b4dbc7430b66b224b54ea718f3c1670f49ec3cbdba"
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
