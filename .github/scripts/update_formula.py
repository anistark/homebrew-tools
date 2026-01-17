#!/usr/bin/env python3
"""
Update Homebrew formula with correct PyPI package URLs and SHA256 hashes.
"""
import argparse
import json
import re
import sys
import urllib.request
from typing import Dict, Optional, Tuple


def fetch_pypi_info(package: str, version: Optional[str] = None) -> Dict:
    """Fetch package info from PyPI."""
    if version:
        url = f"https://pypi.org/pypi/{package}/{version}/json"
    else:
        url = f"https://pypi.org/pypi/{package}/json"

    try:
        with urllib.request.urlopen(url) as response:
            return json.loads(response.read())
    except Exception as e:
        print(f"Error fetching {package}: {e}", file=sys.stderr)
        sys.exit(1)


def get_source_dist(data: Dict) -> Tuple[str, str]:
    """Extract source distribution URL and SHA256 from PyPI data."""
    for url_info in data["urls"]:
        if url_info["packagetype"] == "sdist":
            return url_info["url"], url_info["digests"]["sha256"]

    raise ValueError("No source distribution found")


def get_latest_version_matching(package: str, constraint: str) -> str:
    """Get the latest version of a package matching a constraint."""
    # For simplicity, we'll just get the latest version
    # A full implementation would parse the constraint (>=, ==, etc.)
    data = fetch_pypi_info(package)
    return data["info"]["version"]


def update_formula(formula_path: str, package: str, version: str):
    """Update the Homebrew formula file."""
    with open(formula_path, 'r') as f:
        content = f.read()

    # Fetch main package info
    main_data = fetch_pypi_info(package, version)
    main_url, main_sha256 = get_source_dist(main_data)

    print(f"Main package: {package} {version}")
    print(f"  URL: {main_url}")
    print(f"  SHA256: {main_sha256}")

    # Extract dependencies from the package metadata
    requires_dist = main_data["info"].get("requires_dist", [])
    dependencies = {}

    if requires_dist:
        for req in requires_dist:
            # Parse dependency (e.g., "psutil>=7.2.1" or "rich>=14.2.0")
            # Skip dependencies with environment markers
            if ";" in req:
                req = req.split(";")[0].strip()

            match = re.match(r"^([a-zA-Z0-9_-]+)", req)
            if match:
                dep_name = match.group(1)
                # Normalize package name (e.g., py-cpuinfo, typing-extensions)
                dependencies[dep_name] = req

    # Fetch info for each dependency
    resource_updates = {}
    for dep_name in dependencies:
        try:
            dep_data = fetch_pypi_info(dep_name)
            dep_url, dep_sha256 = get_source_dist(dep_data)
            dep_version = dep_data["info"]["version"]

            print(f"Dependency: {dep_name} {dep_version}")
            print(f"  URL: {dep_url}")
            print(f"  SHA256: {dep_sha256}")

            resource_updates[dep_name] = {
                "url": dep_url,
                "sha256": dep_sha256,
                "version": dep_version
            }
        except Exception as e:
            print(f"Warning: Failed to fetch {dep_name}: {e}", file=sys.stderr)

    # Update main package URL and SHA256 (only the first occurrence)
    # Match the class-level url and sha256, not resource blocks
    content = re.sub(
        r'(class \w+ < Formula.*?url\s+)"[^"]*"',
        f'\\1"{main_url}"',
        content,
        count=1,
        flags=re.DOTALL
    )
    content = re.sub(
        r'(class \w+ < Formula.*?url\s+"[^"]*"\s+sha256\s+)"[^"]*"',
        f'\\1"{main_sha256}"',
        content,
        count=1,
        flags=re.DOTALL
    )

    # Update each resource block
    for dep_name, info in resource_updates.items():
        # Normalize dep_name for matching (e.g., py_cpuinfo vs py-cpuinfo)
        pattern = re.escape(dep_name).replace(r'\_', r'[-_]').replace(r'\-', r'[-_]')

        # Find and update the resource block
        resource_pattern = rf'(resource\s+"{pattern}"\s+do\s+url\s+)"[^"]*"'
        if re.search(resource_pattern, content, re.IGNORECASE):
            content = re.sub(
                resource_pattern,
                f'\\1"{info["url"]}"',
                content,
                flags=re.IGNORECASE
            )

            sha_pattern = rf'(resource\s+"{pattern}"\s+do\s+url\s+"[^"]*"\s+sha256\s+)"[^"]*"'
            content = re.sub(
                sha_pattern,
                f'\\1"{info["sha256"]}"',
                content,
                flags=re.DOTALL | re.IGNORECASE
            )

    # Update test version assertion
    content = re.sub(
        r'(assert_match\s+)"[^"]*"(\s*,\s*shell_output)',
        f'\\1"{version}"\\2',
        content
    )

    # Write updated content
    with open(formula_path, 'w') as f:
        f.write(content)

    print(f"\n✅ Successfully updated {formula_path}")


def main():
    parser = argparse.ArgumentParser(description="Update Homebrew formula")
    parser.add_argument("formula", help="Formula name (e.g., sot)")
    parser.add_argument("version", help="Package version")
    parser.add_argument("--formula-path", help="Path to formula file")

    args = parser.parse_args()

    formula_path = args.formula_path or f"Formula/{args.formula}.rb"
    update_formula(formula_path, args.formula, args.version)


if __name__ == "__main__":
    main()
