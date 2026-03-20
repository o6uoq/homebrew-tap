class AgentScan < Formula
  desc "Security scanner for agents, MCP servers, and skills"
  homepage "https://github.com/snyk/agent-scan"
  version "0.4.9"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/snyk/agent-scan/releases/download/v0.4.9/agent-scan-0.4.9-macos-arm64"
      sha256 "c51281d85efbcef35177fea5089180052b7ba31b6cea08742275c3d86e142650"
    end
  end

  on_linux do
    if Hardware::CPU.intel? && Hardware::CPU.is_64_bit?
      url "https://github.com/snyk/agent-scan/releases/download/v0.4.9/agent-scan-0.4.9-linux-x86_64"
      sha256 "8f1d5fc84fc2571c62eb7eaf97ceb609a49d445171c7e484a84b1b5b6b03ee9b"
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
