class Try < Formula
  desc "Ephemeral workspace manager with fuzzy search"
  homepage "https://github.com/tobi/try"
  url "https://github.com/tobi/try/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "4520a71a2485e04b09a93514d4818ad24800ea4738b8dceba24e941cbe2fc879"
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
