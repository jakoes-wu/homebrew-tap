# agent-lock 的 Homebrew 配方。安装 GitHub release 附件中的源码包（与 install.sh 用的是同一个包）。
# 发新版本时更新 url 与 sha256：sha256 取该 release 的 SHA256SUMS。
class AgentLock < Formula
  desc "Lock Codex and Claude to the local HTTP proxy"
  homepage "https://github.com/jakoes-wu/agent-lock"
  url "https://github.com/jakoes-wu/agent-lock/releases/download/v0.1.1/agent-lock-v0.1.1.tar.gz"
  sha256 "6373d3bc6e6a6a525f6a5178c040c3345d9ecfcb45826b2add5830e762ec78e6"
  license "MIT"

  depends_on "python@3.13"

  def install
    # 纯标准库，不需要 virtualenv：把包放进 libexec，用包装脚本指定 PYTHONPATH 与解释器。
    # 这一步只安装管理命令。创建 agentnet 和加载防火墙仍是 sudo agent-lock install。
    libexec.install "src/agent_lock"
    (bin/"agent-lock").write <<~SH
      #!/bin/bash
      PYTHONPATH="#{libexec}${PYTHONPATH:+:$PYTHONPATH}" exec "#{formula_opt_bin("python@3.13")}/python3.13" -m agent_lock "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-lock --version")
  end
end
