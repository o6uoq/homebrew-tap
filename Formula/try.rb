class Try < Formula
  desc "CLI tool for managing experimental projects"
  homepage "https://github.com/tobi/try"
  url "https://rubygems.org/gems/try-cli-1.7.1.gem"
  sha256 "cf99a68caa596eecd01ba62047110305028c1efb88af6565f104472e54fd39f7"
  license "MIT"

  # PR ref: https://github.com/tobi/try/pull/33
  # Tap-only until upstream provides a Homebrew formula.

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "install", buildpath/"try-cli-1.7.1.gem", "--no-document", "--install-dir", libexec
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try --version")
  end
end
