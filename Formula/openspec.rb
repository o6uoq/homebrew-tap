require "language/node"

class Openspec < Formula
  desc "AI-native system for spec-driven development"
  homepage "https://github.com/Fission-AI/OpenSpec"
  url "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-1.2.0.tgz"
  sha256 "2aceda94693f1db0b0d2ea3c750a2a418737eab30d026d1d066629945cde98ba"
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
