class Wasmrun < Formula
  desc "WebAssembly Runtime for the command line"
  homepage "https://github.com/anistark/wasmrun"
  url "https://static.crates.io/crates/wasmrun/wasmrun-0.14.0.crate"
  sha256 "05c208224d69cc0caa2c9940ccb78f59aca06978b4c7dc7e110c2c9e21811427"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "0.14.0", shell_output("#{bin}/wasmrun --version")
  end
end
