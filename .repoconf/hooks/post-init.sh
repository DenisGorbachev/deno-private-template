#!/usr/bin/env -S usage bash
#USAGE arg "<dir>"

set -xeuo pipefail

dir=$(realpath "${usage_dir:?}")

while IFS= read -r file; do
  rm "$dir/$file"
done < "$dir/.repoconf/data/init-removed-files"

(
  cd "$dir"

  mise trust
  mise install
  mise exec "npm:lefthook" -- lefthook install
  mise run test

  # remove .repoconf just before the final commit, in the same line
  rm -r "$dir/.repoconf"
  git add .
  git commit -a -m "chore: update package details"
)
