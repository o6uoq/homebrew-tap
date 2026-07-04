require "language/node"

class ContextMode < Formula
  desc "MCP server for local context-window optimization"
  homepage "https://github.com/mksglu/context-mode"
  url "https://registry.npmjs.org/context-mode/-/context-mode-1.0.169.tgz"
  sha256 "09c41e4cf77b21566c76b8ea2fdbd7f3d823055fee2f02c2166fd5bb575daf2c"
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
