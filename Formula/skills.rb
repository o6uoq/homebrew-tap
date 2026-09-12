require "language/node"

class Skills < Formula
  desc "CLI for the open agent skills ecosystem"
  homepage "https://github.com/vercel-labs/skills"
  url "https://registry.npmjs.org/skills/-/skills-1.5.26.tgz"
  sha256 "bc93cd403104ab859abdfbe692ba1fb4429fd2e47c38abb27449a4e8e6ba943c"
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
