require "language/node"

class OhMyCodex < Formula
  desc "Workflow and orchestration layer for OpenAI Codex CLI"
  homepage "https://github.com/Yeachan-Heo/oh-my-codex"
  url "https://registry.npmjs.org/oh-my-codex/-/oh-my-codex-0.18.11.tgz"
  sha256 "65afae9d7cdfb2af401a6926f5c707eb8eff2a22b393bd10cf07f8afdc3dd8a7"
  license "MIT"

  # Tap-only until upstream provides a Homebrew formula.

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      oh-my-codex requires an authenticated OpenAI Codex CLI on PATH.
      Install Codex separately, then run:
        omx doctor
        omx setup
    EOS
  end

  test do
    assert_match "omx", shell_output("#{bin}/omx --help")
  end
end
