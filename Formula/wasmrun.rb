class Wasmrun < Formula
  desc "WebAssembly Runtime for the command line"
  homepage "https://github.com/anistark/wasmrun"
  url "https://static.crates.io/crates/wasmrun/wasmrun-1.0.0.crate"
  sha256 "5339a1df907a69f5ca2193665c6ef5e713c4076c06a456d57cf139da4d7ca40d"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "1.0.0", shell_output("#{bin}/wasmrun --version")
  end
end
