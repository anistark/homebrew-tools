class Sot < Formula
  include Language::Python::Virtualenv

  desc "Command-line System Observation Tool"
  homepage "https://github.com/anistark/sot"
  url "https://files.pythonhosted.org/packages/95/2b/90fe6bd6c7868d04b8ea3491cca98bbbf3572ec8f537dab81d938b3706f5/sot-4.4.2.tar.gz"
  sha256 "06cb4b259a207ff2f44260cbd6b98b5904bc359fcc03a5e8ef813baab3e571e7"
  license "MIT"

  depends_on "python@3.12"

  resource "py-cpuinfo" do
    url "https://files.pythonhosted.org/packages/source/p/py-cpuinfo/py-cpuinfo-9.0.0.tar.gz"
    sha256 "3cdbbf3fac90dc6f118bfd64384f309edeadd902d7c8fb17f02ffa1fc3f49690"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/source/d/distro/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/source/p/psutil/psutil-7.1.3.tar.gz"
    sha256 "dba1aa92c7db5db33d0f3d42f78dc6b1e94a43b3f2bffbb53a8ea6402e2e0f55"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/source/r/rich/rich-14.2.0.tar.gz"
    sha256 "b13dfc53ce6c5c8f02c37ec08ec42dce1b12e950106f21b49e87659d0f3e528b"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/source/t/textual/textual-5.3.0.tar.gz"
    sha256 "07ace7d80f0bcf00d3afa11c6da0faf72e8fd90f4b6a4c00fd0a5c4ba23ec26c"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/source/m/markdown-it-py/markdown_it_py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/source/m/mdurl/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/source/p/pygments/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/source/t/typing-extensions/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4.4.2", shell_output("#{bin}/sot --version")
  end
end
