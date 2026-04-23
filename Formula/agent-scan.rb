class AgentScan < Formula
  desc "Security scanner for agents, MCP servers, and skills"
  homepage "https://github.com/snyk/agent-scan"
  version "0.4.17"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/snyk/agent-scan/releases/download/v0.4.17/agent-scan-0.4.17-macos-arm64"
      sha256 "d07ba26ed6afde01e585c4c47d59217e3b7bec9ecd023b4dfc5188f4ad73fb16"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/snyk/agent-scan/releases/download/v0.4.17/agent-scan-0.4.17-linux-x86_64"
      sha256 "709f982a8f2926a37251757bc15009a0a7ed3d72496b1e507069cd68799230a8"
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
