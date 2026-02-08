class Toad < Formula
  include Language::Python::Virtualenv

  desc "Unified terminal interface for AI coding agents"
  homepage "https://github.com/batrachianai/toad"
  url "https://files.pythonhosted.org/packages/5e/42/22dea0e287f4e5227d9ceea9f152e83dbc490ae0b54b146da2089c89e7a1/batrachian_toad-0.5.38.tar.gz"
  sha256 "e586e65c711ac93fdab458dede93879b32949d87b80e30f30e6b5603e4b68c04"
  license "MIT"

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output("#{bin}/toad --help")
  end
end
