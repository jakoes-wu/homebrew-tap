class Ownexit < Formula
  include Language::Python::Virtualenv

  desc "Turn a VPS you rent into your own fixed exit IP"
  homepage "https://github.com/jakoes-wu/ownexit"
  url "https://files.pythonhosted.org/packages/82/8f/f56eb7b54bd85e1b1469625d971d28e8fbfce1b81293ec2f44d89744f2e6/ownexit-2.0.0.tar.gz"
  sha256 "d408196a5a56fd2d093017b4e7208872b8ad598776082eefc182e7e0b4eb1c47"
  license "MIT"

  depends_on "python@3.14"
  depends_on "qrencode"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ownexit --version")
    system bin/"ownexit", "direct", "--help"
  end
end
