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
            if line[0] not in ("+", "-"):
                continue

            found_slugs_on_line = []
            found_slugs_on_line += re.findall(
                    r'{{<\s*' + re.escape(listing_macro_name) + r'\s*"([^"]+)"\s*>}}', line
            )
            if match := re.match(r"\+\[([-\w]+)\]", line):
                found_slugs_on_line += [match[1]]

            added_or_removed = "added" if line[0] == "+" else "removed"
            for slug in found_slugs_on_line:
                # Avoid putting duplicates in slug list, but preserve order of first appearance
                if slug not in slugs_to_check:
                    print(f"Detected {added_or_removed} slug '{slug}' in the diff.")
                    slugs_to_check += [slug]

    if slugs_to_check:
        num_to_check = len(slugs_to_check)
        pluralize = "s" if num_to_check > 1 else ""
        print(f"Checking usages of {num_to_check} unique added or removed slug{pluralize}...")

    for slug in slugs_to_check:
        # If the slug is not in the artifact list, we're all good
        # (it was removed)
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
