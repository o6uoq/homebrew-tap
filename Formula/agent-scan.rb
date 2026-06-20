class AgentScan < Formula
  desc "Security scanner for agents, MCP servers, and skills"
  homepage "https://github.com/snyk/agent-scan"
  version "0.5.11"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/snyk/agent-scan/releases/download/v0.5.11/agent-scan-0.5.11-macos-x86_64"
      sha256 "0db3a5cfb9fe92c26325137cfebe5539e902353b38460ab5c9e13da624a6f124"
    end

    if Hardware::CPU.arm?
      url "https://github.com/snyk/agent-scan/releases/download/v0.5.11/agent-scan-0.5.11-macos-arm64"
      sha256 "dfab490ab9e1c9313113cc52910bf7c0c80578808890d1603e8eb686c66d2852"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/snyk/agent-scan/releases/download/v0.5.11/agent-scan-0.5.11-linux-x86_64"
      sha256 "8e466170dbdad7b87b5e8b05907cbc19ec5ab736a736593812c17d724c542129"
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
