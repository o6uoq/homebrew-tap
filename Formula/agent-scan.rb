class AgentScan < Formula
  desc "Security scanner for agents, MCP servers, and skills"
  homepage "https://github.com/snyk/agent-scan"
  version "0.6.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/snyk/agent-scan/releases/download/v0.6.3/agent-scan-0.6.3-macos-x86_64"
      sha256 "686b2daaa448fcfd15df2bb499a4a81106e8696934c851030ecce1062abb3b68"
    end

    if Hardware::CPU.arm?
      url "https://github.com/snyk/agent-scan/releases/download/v0.6.3/agent-scan-0.6.3-macos-arm64"
      sha256 "6fe659be8fab5c09552960bad91036bdd2bd2dac2c5d8691d6357720052d3647"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/snyk/agent-scan/releases/download/v0.6.3/agent-scan-0.6.3-linux-x86_64"
      sha256 "551ef9f274750c70c3e018a9425086ee3660b46286b88edf9a44d0bef9db6212"
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
