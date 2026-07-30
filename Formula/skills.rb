require "language/node"

class Skills < Formula
  desc "CLI for the open agent skills ecosystem"
  homepage "https://github.com/vercel-labs/skills"
  url "https://registry.npmjs.org/skills/-/skills-1.5.21.tgz"
  sha256 "10a7008ca357242001d765eba31b232de7b0897d9796b21fa0a76ab17729f9b3"
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
