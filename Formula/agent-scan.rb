class AgentScan < Formula
  desc "Security scanner for agents, MCP servers, and skills"
  homepage "https://github.com/snyk/agent-scan"
  version "0.5.13"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/snyk/agent-scan/releases/download/v0.5.13/agent-scan-0.5.13-macos-x86_64"
      sha256 "1ca8b7e42b17feb2de6f1584ee62b694e64b57f28f588bc094c54ed6081c7a14"
    end

    if Hardware::CPU.arm?
      url "https://github.com/snyk/agent-scan/releases/download/v0.5.13/agent-scan-0.5.13-macos-arm64"
      sha256 "7907e46c89c399c0d91e09707e637733591e2b2f4cec1c2130874ccf147d6745"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/snyk/agent-scan/releases/download/v0.5.13/agent-scan-0.5.13-linux-x86_64"
      sha256 "8e605ee8426edd2acced0adb8305b38cfc3ff3f07204d80a370d6a77f21b20bd"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.intel?
      bin.install "agent-scan-#{version}-macos-x86_64" => "snyk-agent-scan"
    elsif OS.mac? && Hardware::CPU.arm?
      bin.install "agent-scan-#{version}-macos-arm64" => "snyk-agent-scan"
    elsif OS.linux? && Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      bin.install "agent-scan-#{version}-linux-x86_64" => "snyk-agent-scan"
    else
      odie "agent-scan is only supported on macOS arm64, macOS x86_64, and Linux x86_64"
    end
  end

  test do
    assert_path_exists bin/"snyk-agent-scan"
  end
end
