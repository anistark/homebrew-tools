#!/usr/bin/env python3
"""
Sync the Version column of the README formulae table with Formula/*.rb.
"""
import argparse
import re
import sys
from pathlib import Path
from typing import Dict, Optional

# Matches the version in a release filename, e.g. "wasmrun-1.0.0.crate",
# "sot-6.3.0.tar.gz" or "v0.7.0.tar.gz"
VERSION_IN_URL = re.compile(r'v?(\d+(?:\.\d+)+(?:[-.]?[A-Za-z0-9.]+?)?)\.(?:crate|tar\.gz|tgz|zip)$')


def formula_version(formula_path: Path) -> Optional[str]:
    """Get the version a formula installs, from `version` or its main url."""
    content = formula_path.read_text()

    explicit = re.search(r'^\s*version\s+"([^"]+)"', content, re.MULTILINE)
    if explicit:
        return explicit.group(1)

    # The first url is the class-level one, resource blocks come after it
    url = re.search(r'^\s*url\s+"([^"]+)"', content, re.MULTILINE)
    if not url:
        return None

    match = VERSION_IN_URL.search(url.group(1).rsplit("/", 1)[-1])
    return match.group(1) if match else None


def sync_readme(readme_path: Path, versions: Dict[str, str]) -> bool:
    """Rewrite the Version cell of each formula row. Returns True on change."""
    content = readme_path.read_text()

    def replace_row(match: re.Match) -> str:
        name = match.group(1)
        if name not in versions:
            return match.group(0)
        return f"| {name} | {versions[name]} |"

    updated = re.sub(
        r'^\| ([a-z0-9][a-z0-9-]*) \| [^|]* \|',
        replace_row,
        content,
        flags=re.MULTILINE
    )

    if updated == content:
        return False

    readme_path.write_text(updated)
    return True


def main():
    parser = argparse.ArgumentParser(description="Sync README formula versions")
    parser.add_argument("--formula-dir", default="Formula", help="Path to formulae")
    parser.add_argument("--readme", default="README.md", help="Path to README")

    args = parser.parse_args()

    versions = {}
    for formula_path in sorted(Path(args.formula_dir).glob("*.rb")):
        version = formula_version(formula_path)
        if version is None:
            print(f"Warning: no version found in {formula_path}", file=sys.stderr)
            continue
        versions[formula_path.stem] = version
        print(f"{formula_path.stem}: {version}")

    if sync_readme(Path(args.readme), versions):
        print(f"\n✅ Updated versions in {args.readme}")
    else:
        print(f"\nℹ️ {args.readme} already up to date")


if __name__ == "__main__":
    main()
