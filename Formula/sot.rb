class Sot < Formula
  include Language::Python::Virtualenv

  desc "Command-line System Observation Tool"
  homepage "https://github.com/anistark/sot"
  url "https://files.pythonhosted.org/packages/a8/2e/15974d1612878f5d97d9cbf02f44093258d978b984b0a723fbd73fdc54f4/sot-5.1.0.tar.gz"
  sha256 "580732c018cb1cb2b7164d88e8129b7b4a93a901b66f1a6eff8301da39ae7ff4"
  license "MIT"

  depends_on "python@3.12"

  resource "py-cpuinfo" do
    url "https://files.pythonhosted.org/packages/a8/2e/15974d1612878f5d97d9cbf02f44093258d978b984b0a723fbd73fdc54f4/sot-5.1.0.tar.gz"
    sha256 "580732c018cb1cb2b7164d88e8129b7b4a93a901b66f1a6eff8301da39ae7ff4"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a8/2e/15974d1612878f5d97d9cbf02f44093258d978b984b0a723fbd73fdc54f4/sot-5.1.0.tar.gz"
    sha256 "580732c018cb1cb2b7164d88e8129b7b4a93a901b66f1a6eff8301da39ae7ff4"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/a8/2e/15974d1612878f5d97d9cbf02f44093258d978b984b0a723fbd73fdc54f4/sot-5.1.0.tar.gz"
    sha256 "580732c018cb1cb2b7164d88e8129b7b4a93a901b66f1a6eff8301da39ae7ff4"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a8/2e/15974d1612878f5d97d9cbf02f44093258d978b984b0a723fbd73fdc54f4/sot-5.1.0.tar.gz"
    sha256 "580732c018cb1cb2b7164d88e8129b7b4a93a901b66f1a6eff8301da39ae7ff4"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/a8/2e/15974d1612878f5d97d9cbf02f44093258d978b984b0a723fbd73fdc54f4/sot-5.1.0.tar.gz"
    sha256 "580732c018cb1cb2b7164d88e8129b7b4a93a901b66f1a6eff8301da39ae7ff4"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/a8/2e/15974d1612878f5d97d9cbf02f44093258d978b984b0a723fbd73fdc54f4/sot-5.1.0.tar.gz"
    sha256 "580732c018cb1cb2b7164d88e8129b7b4a93a901b66f1a6eff8301da39ae7ff4"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/a8/2e/15974d1612878f5d97d9cbf02f44093258d978b984b0a723fbd73fdc54f4/sot-5.1.0.tar.gz"
    sha256 "580732c018cb1cb2b7164d88e8129b7b4a93a901b66f1a6eff8301da39ae7ff4"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/a8/2e/15974d1612878f5d97d9cbf02f44093258d978b984b0a723fbd73fdc54f4/sot-5.1.0.tar.gz"
    sha256 "580732c018cb1cb2b7164d88e8129b7b4a93a901b66f1a6eff8301da39ae7ff4"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/a8/2e/15974d1612878f5d97d9cbf02f44093258d978b984b0a723fbd73fdc54f4/sot-5.1.0.tar.gz"
    sha256 "580732c018cb1cb2b7164d88e8129b7b4a93a901b66f1a6eff8301da39ae7ff4"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/a8/2e/15974d1612878f5d97d9cbf02f44093258d978b984b0a723fbd73fdc54f4/sot-5.1.0.tar.gz"
    sha256 "580732c018cb1cb2b7164d88e8129b7b4a93a901b66f1a6eff8301da39ae7ff4"
  end

  def install
    virtualenv_install_with_resources

    # Install man page
    man1.install "man/sot.1"
  end

  test do
    assert_match "5.1.0", shell_output("#{bin}/sot --version")

    # Verify man page is installed
    assert_predicate man1/"sot.1", :exist?
  end
end
