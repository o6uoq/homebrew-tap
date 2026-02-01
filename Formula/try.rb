class Try < Formula
  desc "Ephemeral workspace manager with fuzzy search"
  homepage "https://github.com/tobi/try"
  url "https://github.com/tobi/try/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "267f2b63561de396a8938c6f41e68e8cecc635d05c582a1f866c0bbf37676af2"
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
