class AgentScan < Formula
  desc "Security scanner for agents, MCP servers, and skills"
  homepage "https://github.com/snyk/agent-scan"
  version "0.6.10"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/snyk/agent-scan/releases/download/v0.6.10/agent-scan-0.6.10-macos-x86_64"
      sha256 "5e38d66d5add1e12bd62e6390417ff5bb901ef07328f238b65de7a6c4e20461d"
    end

    if Hardware::CPU.arm?
      url "https://github.com/snyk/agent-scan/releases/download/v0.6.10/agent-scan-0.6.10-macos-arm64"
      sha256 "76e3fc2966c226124067c1f21104f5719aae6174231e720cf02747a4b22f9968"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/snyk/agent-scan/releases/download/v0.6.10/agent-scan-0.6.10-linux-x86_64"
      sha256 "6c18646a4e91a8b15915deea461cb123d26c8439d4a9e4f65f47435fff4a88f6"
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
