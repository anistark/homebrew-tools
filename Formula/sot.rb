class Sot < Formula
  include Language::Python::Virtualenv

  desc "Command-line System Observation Tool"
  homepage "https://github.com/anistark/sot"
  url "https://files.pythonhosted.org/packages/c0/e3/eb84c0e0240a5a9bc2a2eb7e369d1eba2c6b10dec97f87a20e7c1cd27b72/sot-6.0.0.tar.gz"
  sha256 "bc684d916df26d1c0bc9adfe29352ae84baf1601cd2fb284f6492e9e3f951ea3"
  license "MIT"

  depends_on "python@3.12"

  resource "py-cpuinfo" do
    url "https://files.pythonhosted.org/packages/c0/e3/eb84c0e0240a5a9bc2a2eb7e369d1eba2c6b10dec97f87a20e7c1cd27b72/sot-6.0.0.tar.gz"
    sha256 "bc684d916df26d1c0bc9adfe29352ae84baf1601cd2fb284f6492e9e3f951ea3"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/c0/e3/eb84c0e0240a5a9bc2a2eb7e369d1eba2c6b10dec97f87a20e7c1cd27b72/sot-6.0.0.tar.gz"
    sha256 "bc684d916df26d1c0bc9adfe29352ae84baf1601cd2fb284f6492e9e3f951ea3"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/c0/e3/eb84c0e0240a5a9bc2a2eb7e369d1eba2c6b10dec97f87a20e7c1cd27b72/sot-6.0.0.tar.gz"
    sha256 "bc684d916df26d1c0bc9adfe29352ae84baf1601cd2fb284f6492e9e3f951ea3"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/e3/eb84c0e0240a5a9bc2a2eb7e369d1eba2c6b10dec97f87a20e7c1cd27b72/sot-6.0.0.tar.gz"
    sha256 "bc684d916df26d1c0bc9adfe29352ae84baf1601cd2fb284f6492e9e3f951ea3"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/c0/e3/eb84c0e0240a5a9bc2a2eb7e369d1eba2c6b10dec97f87a20e7c1cd27b72/sot-6.0.0.tar.gz"
    sha256 "bc684d916df26d1c0bc9adfe29352ae84baf1601cd2fb284f6492e9e3f951ea3"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/c0/e3/eb84c0e0240a5a9bc2a2eb7e369d1eba2c6b10dec97f87a20e7c1cd27b72/sot-6.0.0.tar.gz"
    sha256 "bc684d916df26d1c0bc9adfe29352ae84baf1601cd2fb284f6492e9e3f951ea3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/c0/e3/eb84c0e0240a5a9bc2a2eb7e369d1eba2c6b10dec97f87a20e7c1cd27b72/sot-6.0.0.tar.gz"
    sha256 "bc684d916df26d1c0bc9adfe29352ae84baf1601cd2fb284f6492e9e3f951ea3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c0/e3/eb84c0e0240a5a9bc2a2eb7e369d1eba2c6b10dec97f87a20e7c1cd27b72/sot-6.0.0.tar.gz"
    sha256 "bc684d916df26d1c0bc9adfe29352ae84baf1601cd2fb284f6492e9e3f951ea3"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/c0/e3/eb84c0e0240a5a9bc2a2eb7e369d1eba2c6b10dec97f87a20e7c1cd27b72/sot-6.0.0.tar.gz"
    sha256 "bc684d916df26d1c0bc9adfe29352ae84baf1601cd2fb284f6492e9e3f951ea3"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/c0/e3/eb84c0e0240a5a9bc2a2eb7e369d1eba2c6b10dec97f87a20e7c1cd27b72/sot-6.0.0.tar.gz"
    sha256 "bc684d916df26d1c0bc9adfe29352ae84baf1601cd2fb284f6492e9e3f951ea3"
  end

  def install
    virtualenv_install_with_resources

    # Install man page
    man1.install "man/sot.1"
  end

  test do
    assert_match "6.0.0", shell_output("#{bin}/sot --version")

    # Verify man page is installed
    assert_predicate man1/"sot.1", :exist?
  end
end
