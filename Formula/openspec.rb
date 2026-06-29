require "language/node"

class Openspec < Formula
  desc "AI-native system for spec-driven development"
  homepage "https://github.com/Fission-AI/OpenSpec"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.5.0.tgz"
  sha256 "9e0c3c1b88ed3e8de9e976916104ca4f3cc8b17aded4a61d8d25595c58b1b8e2"
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
