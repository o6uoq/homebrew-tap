require "language/node"

class Openspec < Formula
  desc "AI-native system for spec-driven development"
  homepage "https://github.com/Fission-AI/OpenSpec"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.4.0.tgz"
  sha256 "b0ed5b14e3ff20ed45e1f7b5f1a37c847db437386b5fa2c98097fff8a0537f78"
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
