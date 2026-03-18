require "language/node"

class JiraCli < Formula
  desc "Command-line client for the Jira API"
  homepage "https://github.com/foxythemes/jira-cli"
  url "https://registry.npmjs.org/jira-cl/-/jira-cl-1.2.2.tgz"
  sha256 "a1b1795e321afd51d33cd03a86adda0b1c0c565f7ed69f74ae23a8817806e477"
  license "MIT"

  # Tap-only until upstream provides a Homebrew formula.

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/".jira-cli.json").write <<~JSON
      {"protocol":"https","host":"example.atlassian.net","username":"test","password":"test","apiVersion":"2","strictSSL":true}
    JSON
    output = shell_output("HOME=#{testpath} #{bin}/jira --help")
    assert_match "Usage", output
  end
end
