require "language/node"
require "json"

class TmuxIde < Formula
  desc "Turn any project into a tmux-powered terminal IDE with a simple ide.yml"
  homepage "https://github.com/wavyrai/tmux-ide"
  url "https://registry.npmjs.org/tmux-ide/-/tmux-ide-2.0.0.tgz"
  sha256 "28d10432ed9bef4c58bffc67824ddcfc8c9c03c75f8f4f9a33f10582efd09b84"
  license "MIT"

  # Tap-only until upstream provides a Homebrew formula.

  depends_on "node"
  depends_on "bun"
  depends_on "tmux"

  def install
    # Upstream postinstall copies a skill into ~/.claude when present.
    # Keep the formula install side-effect free.
    ENV["HOME"] = buildpath

    # Upstream currently declares a darwin-only binary as a hard dependency.
    # Remove it so npm can resolve via @opentui/core cross-platform.
    package_json = buildpath/"package.json"
    package = JSON.parse(package_json.read)
    package.fetch("dependencies", {}).delete("@opentui/core-darwin-arm64")
    package_json.atomic_write("#{JSON.pretty_generate(package)}\n")

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmux-ide --version")
    assert_match "tmux", shell_output("#{bin}/tmux-ide doctor --json")
  end
end
