require "language/node"

class Skills < Formula
  desc "CLI for the open agent skills ecosystem"
  homepage "https://github.com/vercel-labs/skills"
  url "https://registry.npmjs.org/skills/-/skills-1.5.1.tgz"
  sha256 "c351b70fb3af3f36d1385883c42338c7fab35ccd8b19060fd0eca4d262422240"
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
