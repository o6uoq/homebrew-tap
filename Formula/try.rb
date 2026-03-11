class Try < Formula
  desc "Ephemeral workspace manager with fuzzy search"
  homepage "https://github.com/tobi/try"
  url "https://github.com/tobi/try/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "ae1917c7349d3ea41be829b21ef5e4a362e629a923a442d4da525b77cb3117c0"
  license "MIT"

  # PR ref: https://github.com/tobi/try/pull/33
  # Tap-only until upstream provides a Homebrew formula.
  # Note: uses Data.define which requires Ruby 3.2+ but is broken in Ruby 4.0

  depends_on "ruby@3.3"

  def install
    libexec.install "try.rb", "lib"
    (bin/"try").write_env_script libexec/"try.rb", PATH: "#{Formula["ruby@3.3"].opt_bin}:$PATH"
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
    assert_match "ephemeral workspace manager", shell_output("#{bin}/try --help")
  end
end
