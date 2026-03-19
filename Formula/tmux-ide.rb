require "language/node"

class TmuxIde < Formula
  desc "Turn any project into a tmux-powered terminal IDE with a simple ide.yml"
  homepage "https://github.com/wavyrai/tmux-ide"
  url "https://registry.npmjs.org/tmux-ide/-/tmux-ide-1.2.1.tgz"
  sha256 "53999dc43eff34cf57918914df3cbf9392af126b7b8c1d7d9a6a17e6a9411434"
  license "MIT"

  # Tap-only until upstream provides a Homebrew formula.

  depends_on "node"
  depends_on "tmux"

  def install
    # Upstream postinstall copies a skill into ~/.claude when present.
    # Keep the formula install side-effect free.
    ENV["HOME"] = buildpath

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmux-ide --version")
    assert_match "tmux", shell_output("#{bin}/tmux-ide doctor --json")
  end
end
