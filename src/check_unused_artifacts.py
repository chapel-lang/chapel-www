#!/usr/bin/env python3

import argparse
import tomllib
import re
import sys
import subprocess

# Given the artifact list to check against and a git diff, check if any artifact
# slugs added or removed in the diff are unused.

listing_macro_name = "artifact-listing"

def main():
    parser = argparse.ArgumentParser(description="Lint Chapel artifacts list")
    parser.add_argument("artifacts_filename", type=str, help="Path to the artifacts list file")
    parser.add_argument("diff_filename", type=str, help="Path to the diff to search for newly missing artifacts in")
    args = parser.parse_args()

    slugs_to_check = []
    all_slugs = set()
    unused_slugs = set()

    with open(args.artifacts_filename, "rb") as f:
        data = tomllib.load(f)
        for slug in data:
            all_slugs.add(slug)

    with open(args.diff_filename, "r") as diff:
        for line in diff:
            if line.startswith("-") and listing_macro_name in line:
                removed_slug = line.split("\"")[1]
                print(f"Detected removed slug '{removed_slug}' in the diff.")
                slugs_to_check.append(removed_slug)
            if line.startswith("+"):
                match = re.search(r"^\+\[(\w+)\]$", line)
                if match:
                    added_slug = match.group(1)
                    print(f"Detected added slug '{added_slug}' in the diff.")
                    slugs_to_check.append(added_slug)

    for slug in slugs_to_check:
        if slug not in all_slugs:
            continue
        search_string = f"{listing_macro_name} \"{slug}\""
        if subprocess.run(["git", "grep", "-q", search_string]).returncode != 0:
            unused_slugs.add(slug)

    if unused_slugs:
        print()
        print("The following slugs are unused in the codebase:")
        for slug in unused_slugs:
            print(f"  - {slug}")
        sys.exit(1)
    else:
        print("No unused slugs found in diff.")


if __name__ == "__main__":
    main()
