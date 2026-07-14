require "language/node"

class Skills < Formula
  desc "CLI for the open agent skills ecosystem"
  homepage "https://github.com/vercel-labs/skills"
  url "https://registry.npmjs.org/skills/-/skills-1.5.17.tgz"
  sha256 "3a1e7b338fd2268a895fc100c7008fb28b4816d4d6c14c1404fd102a61c9a49c"
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
