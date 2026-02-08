#!/bin/zsh

# Generates documentation
dart doc .

# Checks if the package is ready to publish without actually uploading it
dart pub publish --dry-run
