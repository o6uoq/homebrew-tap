require "language/node"

class OpenSlide < Formula
  desc "Scaffold open-slide presentation workspaces"
  homepage "https://github.com/1weiho/open-slide"
  url "https://registry.npmjs.org/@open-slide/cli/-/cli-1.4.1.tgz"
  sha256 "f72ac606af57a8ff0e6af0dabfa2c498324a11e4005758dc11f7f8e94b89a8fe"
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
