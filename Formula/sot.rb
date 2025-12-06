class Sot < Formula
  include Language::Python::Virtualenv

  desc "Command-line System Observation Tool"
  homepage "https://github.com/anistark/sot"
  url "https://files.pythonhosted.org/packages/a2/ab/47857ca85332e2afe9fd54e439f51b2c6fe54e37c38ec951a689e369047d/sot-5.0.0.tar.gz"
  sha256 "a9dc126a6b4c7edb7d516f0ab06f7d4bba04c4848c6459b584c293c61124f680"
  license "MIT"

  depends_on "python@3.12"

  resource "py-cpuinfo" do
    url "https://files.pythonhosted.org/packages/a2/ab/47857ca85332e2afe9fd54e439f51b2c6fe54e37c38ec951a689e369047d/sot-5.0.0.tar.gz"
    sha256 "a9dc126a6b4c7edb7d516f0ab06f7d4bba04c4848c6459b584c293c61124f680"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a2/ab/47857ca85332e2afe9fd54e439f51b2c6fe54e37c38ec951a689e369047d/sot-5.0.0.tar.gz"
    sha256 "a9dc126a6b4c7edb7d516f0ab06f7d4bba04c4848c6459b584c293c61124f680"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/a2/ab/47857ca85332e2afe9fd54e439f51b2c6fe54e37c38ec951a689e369047d/sot-5.0.0.tar.gz"
    sha256 "a9dc126a6b4c7edb7d516f0ab06f7d4bba04c4848c6459b584c293c61124f680"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a2/ab/47857ca85332e2afe9fd54e439f51b2c6fe54e37c38ec951a689e369047d/sot-5.0.0.tar.gz"
    sha256 "a9dc126a6b4c7edb7d516f0ab06f7d4bba04c4848c6459b584c293c61124f680"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/a2/ab/47857ca85332e2afe9fd54e439f51b2c6fe54e37c38ec951a689e369047d/sot-5.0.0.tar.gz"
    sha256 "a9dc126a6b4c7edb7d516f0ab06f7d4bba04c4848c6459b584c293c61124f680"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/a2/ab/47857ca85332e2afe9fd54e439f51b2c6fe54e37c38ec951a689e369047d/sot-5.0.0.tar.gz"
    sha256 "a9dc126a6b4c7edb7d516f0ab06f7d4bba04c4848c6459b584c293c61124f680"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/a2/ab/47857ca85332e2afe9fd54e439f51b2c6fe54e37c38ec951a689e369047d/sot-5.0.0.tar.gz"
    sha256 "a9dc126a6b4c7edb7d516f0ab06f7d4bba04c4848c6459b584c293c61124f680"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/a2/ab/47857ca85332e2afe9fd54e439f51b2c6fe54e37c38ec951a689e369047d/sot-5.0.0.tar.gz"
    sha256 "a9dc126a6b4c7edb7d516f0ab06f7d4bba04c4848c6459b584c293c61124f680"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/a2/ab/47857ca85332e2afe9fd54e439f51b2c6fe54e37c38ec951a689e369047d/sot-5.0.0.tar.gz"
    sha256 "a9dc126a6b4c7edb7d516f0ab06f7d4bba04c4848c6459b584c293c61124f680"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/a2/ab/47857ca85332e2afe9fd54e439f51b2c6fe54e37c38ec951a689e369047d/sot-5.0.0.tar.gz"
    sha256 "a9dc126a6b4c7edb7d516f0ab06f7d4bba04c4848c6459b584c293c61124f680"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "5.0.0", shell_output("#{bin}/sot --version")
  end
end
