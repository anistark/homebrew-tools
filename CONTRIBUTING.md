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

1. **Release is published** in the source repository (e.g., sot, pdfk, wasmrun)
2. **Source repo waits for the package**: its `update-homebrew.yml` retries until the new version is downloadable from PyPI or crates.io
3. **Dispatches an `update-formula` event** to this tap with the formula name and version
4. **`update-formula.yml` runs `.github/scripts/update_formula.py`**, which picks the registry from the formula's `url`:
   - `static.crates.io`: reads the checksum from the crates.io API (`/api/v1/crates/<name>/<version>`)
   - Anything else is treated as PyPI: takes the source distribution's url and sha256, and refreshes each existing `resource` block to the latest release of that dependency
5. **Formula is rewritten**: `url`, `sha256`, and the version in the `test` block
6. **README is synced**: `.github/scripts/sync_readme_versions.py` updates the Version column of the formulae table
7. **Changes are committed** to main as `<formula>: update to <version>`

### Formulae Updated by Pull Request

`arin` builds from a GitHub tag and doesn't go through `update-formula.yml`. Its `release.yml` in [anistark/arin](https://github.com/anistark/arin) opens a pull request here with a regenerated `Formula/arin.rb`. Edit `packaging/homebrew/arin-formula.rb` in that repo instead of the copy here, since the next release overwrites it.

When the pull request is merged, `sync-readme.yml` updates the README version. It runs on every push to main that touches `Formula/*.rb`, so manual formula edits are covered too.

### Running an Update Manually

```bash
# Update a formula to a specific version
gh workflow run update-formula.yml -f formula=wasmrun -f version=1.0.0

# Re-sync the README versions from Formula/*.rb
gh workflow run sync-readme.yml
```

Or use **Actions → Update Formula → Run workflow** in the GitHub UI.

> [!NOTE]
> Re-running a failed run from the Actions page reuses the commit it originally ran on. If the failure was fixed in a later commit, start a new run instead.

### Setting Up Automation for a New Formula

No changes to `update-formula.yml` are needed. A formula works with the update script as long as:

- The class-level `url` points at `static.crates.io` (Rust) or `files.pythonhosted.org` (PyPI source distribution)
- The `test` block checks the version with `assert_match "<version>", shell_output(...)`. Every check in that form is rewritten to the bare new version
- For PyPI packages, each dependency has a `resource` block named as it is on PyPI. The script only updates existing blocks, so a new dependency needs its block added by hand
- Its row in the README formulae table has the current version in the Version column

#### 1. Create workflow in the source repository

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

      - name: Wait for the package to be published
        run: |
          VERSION="${{ steps.release.outputs.version }}"
          # For crates.io packages
          URL="https://static.crates.io/crates/your-package/your-package-${VERSION}.crate"
          # For PyPI packages
          # URL="https://pypi.org/pypi/your-package/${VERSION}/json"

          # Retry with exponential backoff
          MAX_RETRIES=5
          RETRY_COUNT=0
          RETRY_DELAY=10

          while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
            echo "Attempt $((RETRY_COUNT + 1)): Fetching $URL"
            HTTP_CODE=$(curl -sL -w "%{http_code}" -o /dev/null "$URL")

            if [ "$HTTP_CODE" = "200" ]; then
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
                "version": "${{ steps.release.outputs.version }}"
              }
            }'
```

Only `formula` and `version` are read from the payload. The tap looks up the url and checksum itself, so any `url` or `sha256` fields sent by older workflows are ignored.

#### 2. Add HOMEBREW_TAP_TOKEN secret

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
│   ├── scripts/
│   │   ├── update_formula.py         # Rewrites a formula from crates.io or PyPI
│   │   └── sync_readme_versions.py   # Syncs README versions from Formula/*.rb
│   └── workflows/
│       ├── update-formula.yml        # Automated update workflow
│       └── sync-readme.yml           # README sync on formula changes
├── Casks/                            # For macOS applications (GUI)
├── Formula/                          # For command-line tools
│   ├── arin.rb                       # Example: GitHub tag, updated by pull request
│   ├── pdfk.rb                       # Example: Rust package
│   ├── sot.rb                        # Example: Python package
│   └── wasmrun.rb                    # Example: Rust package
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
