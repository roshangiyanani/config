#!/bin/sh

# Pre-commit hook for cargo projects.
# Stashes any not commited changes, and then checks that:
#   1. cargo fmt has been run
#   2. the project builds
#   3. tests pass
# If those are all successful, pop the stash (restoring the working directory)
# and let git continue the commit.

# Exit on failure
set -e
set -o pipefail

# Stash changes not added
STASH_NAME="$(date "+PRE_COMMIT_HOOK: %Y-%m-%d %H:%M:%S")";
git stash push --keep-index --include-untracked --message "$STASH_NAME"
git clean -f

# Check formatting
printf "Validating format... ";
cargo fmt --quiet -- --check || { echo "FAILED"; exit 1; };
echo "passed.";

# Check compilation
printf "Compiling... ";
cargo build --quiet 2> /dev/null || { echo "FAILED"; exit 1; };
cargo build --tests --quiet 2> /dev/null || { echo "FAILED"; exit 1; };
echo "success.";

# Run cargo test
echo "Testing... ";
cargo test --quiet;

# Restore changes not added, if there were any
git stash list | grep "$STASH_NAME" &> /dev/null && git stash pop --quiet;