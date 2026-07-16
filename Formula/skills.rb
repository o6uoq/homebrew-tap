require "language/node"

class Skills < Formula
  desc "CLI for the open agent skills ecosystem"
  homepage "https://github.com/vercel-labs/skills"
  url "https://registry.npmjs.org/skills/-/skills-1.5.18.tgz"
  sha256 "8fbd0e3b7dff9c9c89af95cf340f6735f38e09a3b299b150405771ff6fa26751"
  license "MIT"

  # Tap-only until upstream provides a Homebrew formula.

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skills --version")
  end
end
