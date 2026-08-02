# Homebrew Tools

Custom Homebrew tap for command-line tools by [@anistark](https://github.com/anistark).

## Installation

Tap the repository and trust it:

```sh
brew tap anistark/tools
brew trust anistark/tools
```

As of [Homebrew 6.0.0](https://docs.brew.sh/Tap-Trust), non-official taps must be
explicitly trusted before their formulae can be installed. `brew trust anistark/tools`
trusts every current and future formula in this tap. If you prefer, trust a single
formula instead:

```sh
brew trust --formula anistark/tools/sot
```

## Available Formulas

| Formula | Description | Install | Repository |
|---------|-------------|---------|------------|
| arin | Annotation layer any agent can draw on | `brew install arin` | [anistark/arin](https://github.com/anistark/arin) |
| pdfk | Modern PDF password CLI | `brew install pdfk` | [anistark/pdfk](https://github.com/anistark/pdfk) |
| sot | CLI System Observation Tool | `brew install sot` | [anistark/sot](https://github.com/anistark/sot) |
| wasmrun | WebAssembly Runtime for the command line | `brew install wasmrun` | [anistark/wasmrun](https://github.com/anistark/wasmrun) |

## Usage

```sh
# Tap, trust, then install in one command
brew install anistark/tools/arin
brew install anistark/tools/pdfk
brew install anistark/tools/sot
brew install anistark/tools/wasmrun

# Or tap and trust first, then install
brew tap anistark/tools
brew trust anistark/tools
brew install arin
brew install pdfk
brew install sot
brew install wasmrun
```

> [!NOTE]
> `arin` is macOS 14 (Sonoma) or later and builds from source, so it needs a Rust
> toolchain and a couple of minutes to compile. From 0.7 it ships as a signed cask
> instead, and the install line becomes `brew install --cask anistark/tools/arin`.

> [!NOTE]
> If `brew install` reports an untrusted tap, run `brew trust anistark/tools`
> (or `brew trust --formula anistark/tools/<name>`) first. See
> [Homebrew Tap Trust](https://docs.brew.sh/Tap-Trust) for details.

## Development

Formulae are automatically updated when new releases are published to the respective repositories.

## License

This tap is licensed under the [BSD 2-Clause License](LICENSE).
