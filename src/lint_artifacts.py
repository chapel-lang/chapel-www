#!/usr/bin/env python3

import argparse

def main():
    parser = argparse.ArgumentParser(description="Lint Chapel artifacts list")
    parser.add_argument("filename", type=str, help="Path to the artifacts list file")
    args = parser.parse_args()

    filename = args.filename
    print("Linting artifacts list:", filename)
    with open(filename, "r") as file:
        lines = file.read().splitlines()
        for line in lines:
            print(line)

if __name__ == "__main__":
    main()
