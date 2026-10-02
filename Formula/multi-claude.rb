# multi-claude 的 Homebrew 配方。安装 GitHub release 附件中的源码包（与 install.sh 用的是同一个包）。
# 发新版本时更新 url 与 sha256：sha256 取该 release 的 SHA256SUMS。
class MultiClaude < Formula
  desc "Run several Claude Code accounts side by side"
  homepage "https://github.com/jakoes-wu/multi-claude"
  url "https://github.com/jakoes-wu/multi-claude/releases/download/v0.6.0/multi-claude-v0.6.0.tar.gz"
  sha256 "2ff58b51304fceff212474dcad8e02d6b2a7e67ce48e5b5528b2d591d3689b46"
  license "MIT"

  depends_on "python@3.13"

  def install
    # 纯标准库，不需要 virtualenv：把包放进 libexec，用包装脚本指定 PYTHONPATH 与解释器。
    libexec.install "src/multi_claude"
    (bin/"multi-claude").write <<~SH
      #!/bin/bash
      PYTHONPATH="#{libexec}${PYTHONPATH:+:$PYTHONPATH}" exec "#{formula_opt_bin("python@3.13")}/python3.13" -m multi_claude "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-claude --version")
    # 无参数时打印上手说明；HOME 指向测试目录，不读真实账号
    ENV["HOME"] = testpath
    assert_match "Get started", shell_output(bin/"multi-claude")
  end
end
