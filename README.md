# Homebrew Tools

Custom Homebrew tap for command-line tools by [@anistark](https://github.com/anistark).

## Installation

Tap the repository:

```sh
brew tap anistark/tools
```

## Available Formulas

| Formula | Description | Install | Repository |
|---------|-------------|---------|------------|
| sot | CLI System Observation Tool | `brew install sot` | [anistark/sot](https://github.com/anistark/sot) |
| wasmrun | WebAssembly Runtime for the command line | `brew install wasmrun` | [anistark/wasmrun](https://github.com/anistark/wasmrun) |

## Usage

```sh
# Tap and install in one command
brew install anistark/tools/sot
brew install anistark/tools/wasmrun

# Or tap first, then install
brew tap anistark/tools
brew install sot
brew install wasmrun
```

## Development

Formulae are automatically updated when new releases are published to the respective repositories.

## License

This tap is licensed under the [BSD 2-Clause License](LICENSE).
