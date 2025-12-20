class Wasmrun < Formula
  desc "WebAssembly Runtime for the command line"
  homepage "https://github.com/anistark/wasmrun"
  url "https://static.crates.io/crates/wasmrun/wasmrun-0.15.0.crate"
  sha256 "0af4911c9d2c4b0fd1c3e664e03eb0fc09be52d50db73a3f2f01d3fa76353285"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "0.14.0", shell_output("#{bin}/wasmrun --version")
  end
end
