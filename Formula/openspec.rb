require "language/node"

class Openspec < Formula
  desc "AI-native system for spec-driven development"
  homepage "https://github.com/Fission-AI/OpenSpec"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.6.0.tgz"
  sha256 "a80477767e98a62e956464ad09a44b28cacc4fcbfde23765f7b4ba598ee13859"
  license "MIT"

  # Tap-only until upstream provides a Homebrew formula.

  depends_on "node"

  def install
    ENV["CI"] = "1"
    ENV["OPENSPEC_NO_COMPLETIONS"] = "1"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"openspec", "init", "--tools", "none", "--force"
    assert_predicate testpath/"openspec/config.yaml", :exist?
  end
end
