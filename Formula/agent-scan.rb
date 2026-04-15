class AgentScan < Formula
  desc "Security scanner for agents, MCP servers, and skills"
  homepage "https://github.com/snyk/agent-scan"
  version "0.4.16"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/snyk/agent-scan/releases/download/v0.4.16/agent-scan-0.4.16-macos-arm64"
      sha256 "431515bcf0a473d625ac663020558296b6ae9780ff88dc0b4d9e73bfd0311198"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/snyk/agent-scan/releases/download/v0.4.16/agent-scan-0.4.16-linux-x86_64"
      sha256 "f764be75c8a02abf0c829e34d06ce5de12a2e4dfea4f3726926ea6198c1adf2c"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "agent-scan-#{version}-macos-arm64" => "snyk-agent-scan"
    elsif OS.linux? && Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      bin.install "agent-scan-#{version}-linux-x86_64" => "snyk-agent-scan"
    else
      odie "agent-scan is only supported on macOS arm64 and Linux x86_64"
    end
  end

  test do
    assert_predicate bin/"snyk-agent-scan", :exist?
  end
end
