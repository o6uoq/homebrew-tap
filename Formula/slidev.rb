require "language/node"

class Slidev < Formula
  desc "Presentation slides for developers"
  homepage "https://sli.dev"
  url "https://registry.npmjs.org/@slidev/cli/-/cli-52.18.1.tgz"
  sha256 "8e040023055e8e611ee2fe21b05cdf49ab7ffdd923b3d9bd9e73177ca0081693"
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
