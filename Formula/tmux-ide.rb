require "language/node"

class TmuxIde < Formula
  desc "Turn any project into a tmux-powered terminal IDE with a simple ide.yml"
  homepage "https://github.com/wavyrai/tmux-ide"
  url "https://registry.npmjs.org/tmux-ide/-/tmux-ide-1.3.1.tgz"
  sha256 "a9b9e37cd9e70fcebcc8b73b4bcd59c310fa74b0ae9ab5a8f58980323022721d"
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
