#!/usr/bin/env python3

import argparse
import tomllib
import sys


# This script is used to lint the artifacts list in the `data/artifacts.toml`
# file, according to the rules described below.

# Each resource is represented as a TOML table, with a unique 'slug' for a name.
# There are both mandatory and optional fields.

required_fields = {
    "title",            # the title of the resource
    "authors",          # the author(s) of the resource
    "date",             # some information about when the resource was created
    "description",      # some information about what the resource is
    "type",             # any types of artifact this resource contains (see valid_types)
}
optional_fields = {
    "venue",            # where the resource originally appeared (required for some types)
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
                        # nor a video, or when you have multiple decks or videos.
                        # If present, extraLinkText must also be present.
    "extraLinkText",    # a name for the extra link
    "linkList",         # a list of several links to be displayed. If present,
                        # linkListTexts and linkListLabel must also be present.
    "linkListTexts",    # respective text to display for each link
    "linkListLabel",    # a label for what the list of links are
}
valid_fields = required_fields | optional_fields
valid_types = {
    "paper",
    "presentation",
    "poster",
    "video",
    "code",
    "misc"
}
types_requiring_venue = {
    "paper",
    "presentation",
    "poster",
}


# BEGIN SCRIPT BODY

def validate_artifact(artifact: dict):
    fields = set(artifact.keys())
    for field, value in artifact.items():
        if field not in valid_fields:
            raise ValueError(f"Unexpected field '{field}'")
        if field == "type":
            has_types_requiring_venue = set(value) & types_requiring_venue
            if "venue" not in fields and has_types_requiring_venue:
                raise ValueError("Missing venue field for types requiring it: " + str(has_types_requiring_venue))
            for type_entry in value:
                if type_entry not in valid_types:
                    raise ValueError(f"Invalid type '{type_entry}'")
            if repeated_types := {x for x in value if value.count(x) > 1}:
                raise ValueError(f"Repeated types '{repeated_types}'")
        elif field == "linkList" or field == "linkListTexts":
            if not isinstance(value, list):
                raise ValueError(f"Field '{field}' must be a list")
            for item in value:
                if not isinstance(item, str):
                    raise ValueError(f"Field '{field}' must be a list of strings")
        else:
            if value.strip() == "":
                raise ValueError(f"Empty value for field {field}")

    if ("extraLink" in fields) != ("extraLinkText" in fields):
        raise ValueError("Must specify extraLink and extraLinkText together")
    if (("linkList" in fields) != ("linkListTexts" in fields)) or (("linkList" in fields) != ("linkListLabel" in fields)):
        raise ValueError("Must specify linkList, linkListTexts, and linkListLabel together")
    if "linkList" in fields and len(artifact["linkList"]) != len(artifact["linkListTexts"]):
        raise ValueError("Mismatch between linkList and linkListTexts lengths")

    required_fields_encountered = fields & required_fields
    if len(required_fields_encountered) != len(required_fields):
        missing_fields = set(required_fields) - required_fields_encountered
        raise ValueError(f"Missing required fields: {missing_fields}")


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
    return errored_slugs


def main():
    parser = argparse.ArgumentParser(description="Lint Chapel artifacts list")
    parser.add_argument("artifacts_filename", type=str, help="Path to the artifacts list file")
    args = parser.parse_args()

    filename = args.artifacts_filename
    print("Linting artifacts list at", filename)
    print()

    with open(filename, "rb") as file:
        data = tomllib.load(file)
        errored_slugs = lint_artifacts_list(data)
        if (errored_slugs):
            print(f"Issues found in {len(errored_slugs)} slugs:")
            for slug, error_msg in errored_slugs.items():
                print(f"  {slug}: {error_msg}")
            sys.exit(1)
        else:
            print("No errors found in artifacts list.")


if __name__ == "__main__":
    main()
