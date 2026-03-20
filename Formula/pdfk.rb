class Pdfk < Formula
  desc "Modern PDF password CLI"
  homepage "https://github.com/anistark/pdfk"
  url "https://static.crates.io/crates/pdfk/pdfk-0.3.0.crate"
  sha256 "82ef4a39d76cfab9989ed32d7c7fdc41ede7a4707f19b72b70fa7c7932e362d1"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "0.3.0", shell_output("#{bin}/pdfk --version")
  end
end
