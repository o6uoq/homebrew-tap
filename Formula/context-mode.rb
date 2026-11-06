require "language/node"

class ContextMode < Formula
  desc "MCP server for local context-window optimization"
  homepage "https://github.com/mksglu/context-mode"
  url "https://registry.npmjs.org/context-mode/-/context-mode-2.1.4.tgz"
  sha256 "58dce75de0f44acc18672f3bb4f16e67f7a7c7b3bd313fb2ee841b7479539c4d"
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
