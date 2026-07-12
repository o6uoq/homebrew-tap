require "language/node"

class Slidev < Formula
  desc "Presentation slides for developers"
  homepage "https://sli.dev"
  url "https://registry.npmjs.org/@slidev/cli/-/cli-52.17.0.tgz"
  sha256 "9225fb81629f6f5d84402bf265a3cdc0c9a101eae3e84c22cb133ecf2d3575bd"
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
