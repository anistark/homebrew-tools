# Contributing to Homebrew Tools

Thank you for your interest in contributing to this Homebrew tap! This guide will help you add new formulae or update existing ones.

## Table of Contents

- [Adding a New Formula](#adding-a-new-formula)
- [Updating Existing Formulae](#updating-existing-formulae)
- [Testing Locally](#testing-locally)
- [Automated Updates](#automated-updates)
- [Formula Guidelines](#formula-guidelines)
- [Getting Help](#getting-help)

## Adding a New Formula

### 1. Create the Formula File

Formulae are organized by first letter in the `Formula/` directory:

```bash
# For a package named "example"
touch Formula/example.rb
```

### 2. Write the Formula

Use this template based on the package type:

#### For Python packages (PyPI):

```ruby
class Example < Formula
  include Language::Python::Virtualenv

  desc "Brief description of the tool"
  homepage "https://github.com/username/example"
  url "https://files.pythonhosted.org/packages/.../example-1.0.0.tar.gz"
  sha256 "checksum-here"
  license "MIT"

  depends_on "python@3.12"

  # Add Python dependencies as resources
  resource "dependency-name" do
    url "https://files.pythonhosted.org/packages/.../dependency-1.0.0.tar.gz"
    sha256 "checksum-here"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "1.0.0", shell_output("#{bin}/example --version")
  end
end
```

#### For Rust packages (crates.io):

```ruby
class Example < Formula
  desc "Brief description of the tool"
  homepage "https://github.com/username/example"
  url "https://static.crates.io/crates/example/example-1.0.0.crate"
  sha256 "checksum-here"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "example 1.0.0", shell_output("#{bin}/example --version")
  end
end
```

#### For GitHub releases:

```ruby
class Example < Formula
  desc "Brief description of the tool"
  homepage "https://github.com/username/example"
  url "https://github.com/username/example/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "checksum-here"
  license "MIT"
  head "https://github.com/username/example.git", branch: "main"

  depends_on "rust" => :build  # or other build dependencies

  def install
    system "cargo", "install", *std_cargo_args  # adjust for your build system
  end

  test do
    assert_match "1.0.0", shell_output("#{bin}/example --version")
  end
end
```

### 3. Calculate SHA256 Checksum

```bash
# For a URL
curl -sL <URL> | shasum -a 256

# Example:
curl -sL https://static.crates.io/crates/example/example-1.0.0.crate | shasum -a 256
```

### 4. Test Locally

See [Testing Locally](#testing-locally) section below.

## Updating Existing Formulae

### Manual Update

1. Edit the formula file (e.g., `Formula/sot.rb`)
2. Update the `url` to the new version
3. Update the `sha256` checksum
4. Update version strings in the `test` block if needed

### Using brew bump-formula-pr

```bash
# For a crates.io package
brew bump-formula-pr \
  --url=https://static.crates.io/crates/example/example-1.1.0.crate \
  example

# For a GitHub release
brew bump-formula-pr \
  --url=https://github.com/username/example/archive/refs/tags/v1.1.0.tar.gz \
  example
```

## Testing Locally

### 1. Audit the Formula

Check for common issues and style violations:

```bash
# From the tap repository root
brew audit --new --strict --online Formula/example.rb
```

### 2. Style Check

Ensure Ruby style compliance:

```bash
brew style Formula/example.rb

# Auto-fix style issues
brew style --fix Formula/example.rb
```

### 3. Install Locally

Test installation from your local tap:

```bash
# Use the full path to test local changes
brew install --build-from-source $(brew --repo anistark/tools)/Formula/example.rb

# Or if already installed, reinstall
brew reinstall --build-from-source $(brew --repo anistark/tools)/Formula/example.rb
```

### 4. Run the Test Block

```bash
brew test example
```

### 5. Verify Installation

```bash
# Check version
example --version

# Check where it's installed
which example

# Verify it's from your tap
brew info example
```

### 6. Uninstall After Testing

```bash
brew uninstall example
```

## Automated Updates

This tap uses GitHub Actions to automatically update formulae when new releases are published.

### How It Works

1. **Release is published** in the source repository (e.g., sot, wasmrun)
2. **GitHub Action triggers** in the source repo
3. **Fetches package info** from PyPI or crates.io (with retry logic)
4. **Dispatches update** to this tap repository
5. **Formula is updated** and committed automatically to main

### Setting Up Automation for a New Formula

If you want to add automation for a new formula:

#### 1. Add update logic to `.github/workflows/update-formula.yml`

Add a new conditional block in the "Update formula" step:

```bash
# Update test version match for your-formula
if [ "$FORMULA" = "your-formula" ]; then
  sed -i "s|assert_match \"your-formula .*\", shell_output|assert_match \"your-formula ${VERSION}\", shell_output|" Formula/${FORMULA}.rb
fi
```

#### 2. Create workflow in the source repository

Add `.github/workflows/update-homebrew.yml` to the source repo:

```yaml
name: Update Homebrew Formula

on:
  release:
    types: [published, prereleased]  # Remove prereleased for stable-only

jobs:
  update-homebrew:
    runs-on: ubuntu-latest
    steps:
      - name: Get release info
        id: release
        run: |
          VERSION="${{ github.event.release.tag_name }}"
          VERSION="${VERSION#v}"
          echo "version=$VERSION" >> $GITHUB_OUTPUT

      # For crates.io packages
      - name: Fetch crates.io package info
        id: crates
        run: |
          VERSION="${{ steps.release.outputs.version }}"
          URL="https://static.crates.io/crates/your-package/your-package-${VERSION}.crate"

          # Retry logic with exponential backoff
          MAX_RETRIES=5
          RETRY_COUNT=0
          RETRY_DELAY=10

          while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
            echo "Attempt $((RETRY_COUNT + 1)): Fetching $URL"
            HTTP_CODE=$(curl -sL -w "%{http_code}" -o /tmp/package.crate "$URL")

            if [ "$HTTP_CODE" = "200" ]; then
              SHA256=$(sha256sum /tmp/package.crate | cut -d' ' -f1)
              echo "url=$URL" >> $GITHUB_OUTPUT
              echo "sha256=$SHA256" >> $GITHUB_OUTPUT
              exit 0
            fi

            RETRY_COUNT=$((RETRY_COUNT + 1))
            if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
              sleep $RETRY_DELAY
              RETRY_DELAY=$((RETRY_DELAY * 2))
            fi
          done
          exit 1

      - name: Trigger homebrew-tools update
        run: |
          curl -X POST \
            -H "Authorization: token ${{ secrets.HOMEBREW_TAP_TOKEN }}" \
            https://api.github.com/repos/anistark/homebrew-tools/dispatches \
            -d '{
              "event_type": "update-formula",
              "client_payload": {
                "formula": "your-formula",
                "version": "${{ steps.release.outputs.version }}",
                "url": "${{ steps.crates.outputs.url }}",
                "sha256": "${{ steps.crates.outputs.sha256 }}"
              }
            }'
```

#### 3. Add HOMEBREW_TAP_TOKEN secret

In the source repository settings:
- Go to Settings → Secrets and variables → Actions
- Add `HOMEBREW_TAP_TOKEN` with a GitHub Personal Access Token
- Token needs `repo` scope

_If you want your repo to be supported by this tap, request a token from @anistark._

## Formula Guidelines

### Best Practices

1. **Description**: Keep it concise (under 80 characters)
2. **License**: Always specify the license
3. **Dependencies**: Only list runtime dependencies (use `=> :build` for build-only)
4. **Test block**: Always include a meaningful test
5. **Version matching**: Update version strings in tests when bumping versions

### Common Patterns

#### For tools with shell completions:

```ruby
def install
  system "cargo", "install", *std_cargo_args
  generate_completions_from_executable(bin/"example", "--completions")
end
```

#### For tools with man pages:

```ruby
def install
  system "cargo", "install", *std_cargo_args
  man1.install "doc/example.1"
end
```

For Python packages with man pages (like `sot`):

```ruby
def install
  virtualenv_install_with_resources

  # Install man page from source tarball
  man1.install "man/example.1"
end

test do
  assert_match "1.0.0", shell_output("#{bin}/example --version")

  # Verify man page is installed
  assert_predicate man1/"example.1", :exist?
end
```

**Note:** Python packages may include man pages in either:
- **Source tarball**: `man/example.1` (install explicitly as shown above)
- **Wheel**: `share/man/man1/example.1` (auto-installed by pip/virtualenv)

The `sot` formula uses the explicit installation method to ensure the man page is always available.

#### For HEAD installs (bleeding edge):

```ruby
head "https://github.com/username/example.git", branch: "main"
```

### Version Strategy

- **This tap**: Include both stable and pre-release versions
- **homebrew-core**: Only stable versions (if/when submitted)

Pre-release versions use suffixes like:
- `0.15.0-alpha.1`
- `0.15.0-beta.2`
- `0.15.0-rc.1`

## Getting Help

- **Homebrew Documentation**: https://docs.brew.sh/
- **Formula Cookbook**: https://docs.brew.sh/Formula-Cookbook
- **Python Formulae**: https://docs.brew.sh/Python-for-Formula-Authors
- **Tap Issues**: https://github.com/anistark/homebrew-tools/issues

## Tap Structure

```sh
homebrew-tools/
├── .github/
│   └── workflows/
│       └── update-formula.yml    # Automated update workflow
├── Casks/                         # For macOS applications (GUI)
├── Formula/                       # For command-line tools
│   ├── sot.rb                     # Example: Python package
│   └── wasmrun.rb                 # Example: Rust package
├── .gitignore
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

## Quick Reference Commands

```bash
# Audit a formula
brew audit --new --strict --online Formula/example.rb

# Style check
brew style Formula/example.rb

# Install locally
brew install --build-from-source $(brew --repo anistark/tools)/Formula/example.rb

# Test
brew test example

# Get tap path
brew --repo anistark/tools

# List all formulae in tap
brew search anistark/tools

# Uninstall
brew uninstall example
```
