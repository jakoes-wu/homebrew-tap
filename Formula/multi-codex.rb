# multi-codex 的 Homebrew 配方。安装 GitHub release 附件中的源码包（与 install.sh 用的是同一个包）。
# 发新版本时更新 url 与 sha256：sha256 取该 release 的 SHA256SUMS。
class MultiCodex < Formula
  desc "Run several Codex CLI accounts side by side"
  homepage "https://github.com/jakoes-wu/multi-codex"
  url "https://github.com/jakoes-wu/multi-codex/releases/download/v0.9.0/multi-codex-v0.9.0.tar.gz"
  sha256 "c9444ee98d787b86bf2c4e65609081254fedd60c5f71ed5a62dbddb73e0fc537"
  license "MIT"

  depends_on "python@3.13"

  def install
    # 纯标准库，不需要 virtualenv：把包放进 libexec，用包装脚本指定 PYTHONPATH 与解释器。
    libexec.install "src/multi_codex"
    (bin/"multi-codex").write <<~SH
      #!/bin/bash
      PYTHONPATH="#{libexec}${PYTHONPATH:+:$PYTHONPATH}" exec "#{formula_opt_bin("python@3.13")}/python3.13" -m multi_codex "$@"
    SH
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/multi-codex --version")
    assert_match "Get started", shell_output("#{bin}/multi-codex -h")
  end
end
