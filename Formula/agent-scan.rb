class AgentScan < Formula
  desc "Security scanner for agents, MCP servers, and skills"
  homepage "https://github.com/snyk/agent-scan"
  version "0.4.13"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/snyk/agent-scan/releases/download/v0.4.13/agent-scan-0.4.13-macos-arm64"
      sha256 "c33343923225ff980f5653cdaaff6e96dd5a19fbfbd94b8bb535c8cf21b8b388"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/snyk/agent-scan/releases/download/v0.4.13/agent-scan-0.4.13-linux-x86_64"
      sha256 "899a77c35a6c8428ef9b9cba62258716323889bfdd4510f7453ca04c919ede84"
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
