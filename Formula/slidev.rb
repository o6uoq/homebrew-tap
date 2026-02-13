require "language/node"

class Slidev < Formula
  desc "Presentation slides for developers"
  homepage "https://sli.dev"
  url "https://registry.npmjs.org/@slidev/cli/-/cli-52.12.0.tgz"
  sha256 "750a18f17ac8f3f7cafb46762d57bf6e833cb69782bb21d526c1431aac70f570"
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
