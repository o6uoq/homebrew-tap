require "language/node"

class Slidev < Formula
  desc "Presentation slides for developers"
  homepage "https://sli.dev"
  url "https://registry.npmjs.org/@slidev/cli/-/cli-53.2.0.tgz"
  sha256 "3044af68d485ca4fe18c5421cc344d1c9e22ac1c36e86fa80de6c7267017daea"
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
