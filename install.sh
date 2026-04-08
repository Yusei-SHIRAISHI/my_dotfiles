#!/bin/sh

set -eu

current_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if ! command -v chezmoi >/dev/null 2>&1; then
  printf '%s\n' 'chezmoi is required. Install it first: https://www.chezmoi.io/install/' >&2
  exit 1
fi

exec chezmoi apply --source "$current_dir" --verbose
