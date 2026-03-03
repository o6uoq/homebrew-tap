require "language/node"

class Slidev < Formula
  desc "Presentation slides for developers"
  homepage "https://sli.dev"
  url "https://registry.npmjs.org/@slidev/cli/-/cli-52.14.0.tgz"
  sha256 "5cdc9371edd47e6cfb846b07e0a0134379d69870eac8aef799c4313d576bedba"
  license "MIT"

  # PR ref: https://github.com/slidevjs/slidev/pull/2437
  # Tap-only until upstream provides a Homebrew formula.

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slidev --version")
  end
end
