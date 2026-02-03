class Try < Formula
  desc "Ephemeral workspace manager with fuzzy search"
  homepage "https://github.com/tobi/try"
  url "https://github.com/tobi/try/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "8c6cd6e1b6fc987732f892743c402035235995180c51a2f916845c2ee800bce6"
  license "MIT"

  # PR ref: https://github.com/tobi/try/pull/33
  # Tap-only until upstream provides a Homebrew formula.
  # Note: main branch uses Data.define which is incompatible with Ruby 4.0

  depends_on "ruby"

  def install
    bin.install "try.rb" => "try"
  end

  def caveats
    <<~EOS
      To set up try with your shell, add one of the following:

      For bash/zsh:
        eval "$(try init ~/src/tries)"

      For fish:
        eval "(try init ~/src/tries | string collect)"
    EOS
  end

  test do
    assert_match "try init", shell_output("#{bin}/try --help")
  end
end
