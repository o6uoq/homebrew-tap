class Try < Formula
  desc "Ephemeral workspace manager with fuzzy search"
  homepage "https://github.com/tobi/try"
  url "https://github.com/tobi/try/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "b3e0f2cd86116c19927dfe178456b409be485fa7fdd5cb79ab7fc2b9853e9acd"
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
