#!/usr/bin/env python3

import argparse
import tomllib

required_keys = {
    "title",
    "authors",
    "venue",
    "date",
    "description",
    "type",
}
optional_keys = {
    "url",
    "slides",
    "video",
    "extraLink",
    "extraLinkText",
}
valid_keys = required_keys | optional_keys
valid_types = {"paper", "presentation", "poster", "video", "code", "misc"}

def validate_artifact(artifact: dict):
    required_keys_encountered = set()
    for key, value in artifact.items():
        if key not in valid_keys:
            raise ValueError(f"Unexpected key '{key}'")
        if key in required_keys:
            required_keys_encountered.add(key)
        if key == "type":
            for type_entry in value:
                if type_entry not in valid_types:
                    raise ValueError(f"Invalid type '{type_entry}'")
        else:
            if value.strip() == "":
                raise ValueError(f"Empty value for key {key}")

    if len(required_keys_encountered) != len(required_keys):
        missing_keys = set(required_keys) - required_keys_encountered
        raise ValueError(f"Missing required keys: {missing_keys}")


def lint_artifacts_list(data):
    encountered_slugs = set()
    errored_slugs = {}
    for slug in data:
        print(f"Checking slug '{slug}'")
        try:
            if slug in encountered_slugs:
                raise ValueError(f"Duplicate slug")
            encountered_slugs.add(slug)
            if not isinstance(slug, str):
                raise ValueError(f"Non-string slug")
            validate_artifact(data[slug])
        except ValueError as e:
            error_msg = f"Error in slug '{slug}': {e}"
            errored_slugs[slug] = error_msg
            print(error_msg)
            continue
    print(f"Checked {len(data)} slugs")
    if (errored_slugs):
        print(f"Errors found in {len(errored_slugs)} slugs:")
        for slug, error_msg in errored_slugs.items():
            print(f"  {slug}: {error_msg}")


def main():
    parser = argparse.ArgumentParser(description="Lint Chapel artifacts list")
    parser.add_argument("filename", type=str, help="Path to the artifacts list file")
    args = parser.parse_args()

    filename = args.filename
    print("Linting artifacts list at", filename)
    with open(filename, "rb") as file:
        data = tomllib.load(file)
        lint_artifacts_list(data)


if __name__ == "__main__":
    main()
