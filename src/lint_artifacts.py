#!/usr/bin/env python3

import argparse
import tomllib


# This script is used to lint the artifacts list in the `data/publications.toml`
# file, according to the rules described below.

# Each resource is represented as a TOML table, with a unique 'slug' for a name.
# There are both mandatory and optional fields.

required_fields = {
    "title",            # the title of the resource
    "authors",          # the author(s) of the resource
    "venue",            # where the resource originally appeared
    "date",             # some information about when the resource was created
    "description",      # some information about what the resource is
    "type",             # any types of artifact this resource contains (see valid_types)
}
optional_fields = {
    "url",              # a link that will be attached to the title of the resource when rendered
    "slides",           # a link to a slide deck relevant to this resource. If this
                        # resource is included, the word "Slides" will appear within brackets
                        # following the name of the resource and will link to the provided URL. It
                        # can be an absolute link leading to an external website or a relative path
                        # to a file internal to the website
    "video",            # a link to a video relevant to this resource. Like the
                        # `slides` field, this will cause the word "Video" to appear
                        # within brackets following the name of the resource
    "extraLink",        # link to an external resource that is neither a slide deck
                        # nor a video, or when you have multiple decks or videos
    "extraLinkText",    # a name for the extra link
}
valid_types = {
    "paper",
    "presentation",
    "poster",
    "video",
    "code",
    "misc"
}


# BEGIN SCRIPT BODY

valid_fields = required_fields | optional_fields

def validate_artifact(artifact: dict):
    for field, value in artifact.items():
        if field not in valid_fields:
            raise ValueError(f"Unexpected field '{field}'")
        if field == "type":
            for type_entry in value:
                if type_entry not in valid_types:
                    raise ValueError(f"Invalid type '{type_entry}'")
        else:
            if value.strip() == "":
                raise ValueError(f"Empty value for field {field}")

    fields = set(artifact.keys())

    if "extraLinkText" in fields and "extraLink" not in fields:
        raise ValueError("Specified extraLinkText without extraLink")

    required_fields_encountered = fields & required_fields
    if len(required_fields_encountered) != len(required_fields):
        missing_keys = set(required_fields) - required_fields_encountered
        raise ValueError(f"Missing required keys: {missing_keys}")


def lint_artifacts_list(data):
    errored_slugs = {}

    for slug in data:
        print(f"Checking slug '{slug}'")
        try:
            if not isinstance(slug, str):
                raise ValueError(f"Non-string slug")
            validate_artifact(data[slug])
        except ValueError as e:
            error_msg = f"Error in slug '{slug}': {e}"
            errored_slugs[slug] = error_msg
            print(error_msg)
            continue

    print()
    print(f"Validated {len(data)} slugs.")
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
    print()
    with open(filename, "rb") as file:
        data = tomllib.load(file)
        lint_artifacts_list(data)


if __name__ == "__main__":
    main()
