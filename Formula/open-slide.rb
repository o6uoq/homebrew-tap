require "language/node"

class OpenSlide < Formula
  desc "Scaffold open-slide presentation workspaces"
  homepage "https://github.com/1weiho/open-slide"
  url "https://registry.npmjs.org/@open-slide/cli/-/cli-2.0.0.tgz"
  sha256 "6fcd590e7b184a3e96491d4ea11c02deddbe3fa3e84f649f9db90264e80ea462"
  license "MIT"

  # Tap-only until upstream provides a Homebrew formula.

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/open-slide --version")
  end
end
