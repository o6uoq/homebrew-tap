class AgentScan < Formula
  desc "Security scanner for agents, MCP servers, and skills"
  homepage "https://github.com/snyk/agent-scan"
  version "0.7.1"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/snyk/agent-scan/releases/download/v0.7.1/agent-scan-0.7.1-macos-x86_64"
      sha256 "d64313a4c839223c3c4531f8d05b0a5e680b8dc7eee42fa73c2acde8962bd889"
    end

    if Hardware::CPU.arm?
      url "https://github.com/snyk/agent-scan/releases/download/v0.7.1/agent-scan-0.7.1-macos-arm64"
      sha256 "9f468bd6ae53b01672371e1f9de2cfb871d1198d034ff8f1b6be0bf508a8bde7"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/snyk/agent-scan/releases/download/v0.7.1/agent-scan-0.7.1-linux-x86_64"
      sha256 "f9a0a35122aa68b767d53889b517eeececc92efb1c9a709e5b551cd3c2509d0e"
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
