require "language/node"

class Openspec < Formula
  desc "AI-native system for spec-driven development"
  homepage "https://github.com/Fission-AI/OpenSpec"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.3.0.tgz"
  sha256 "7e0245e638db3b494aa5e4c49c359688fe6a0cabe7dbe2d6c28fd730582e8e6e"
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
