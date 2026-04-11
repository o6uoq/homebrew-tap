class AgentScan < Formula
  desc "Security scanner for agents, MCP servers, and skills"
  homepage "https://github.com/snyk/agent-scan"
  version "0.4.15"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/snyk/agent-scan/releases/download/v0.4.15/agent-scan-0.4.15-macos-arm64"
      sha256 "ff63aec3f53e574897ae89d480bd70afcda0c39249ffe28cf2e98624f3a897de"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/snyk/agent-scan/releases/download/v0.4.15/agent-scan-0.4.15-linux-x86_64"
      sha256 "54f14102d54f43bd3a470debd58d228e4516fd7a5fea04f94bd68c89655a515c"
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
