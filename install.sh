#!/bin/bash

pushd "$(dirname "${0}")" >/dev/null
BASE_DIR=$(pwd)
popd >/dev/null

pushd "$BASE_DIR" >>/dev/null

if type brew >/dev/null 2>&1; then
  # asdf 0.16 or later (Go implementation) does not provide asdf.sh
  ASDF_SH="$(brew --prefix asdf)/libexec/asdf.sh"
  if [ -f "$ASDF_SH" ]; then
    source "$ASDF_SH"
  fi
fi

if [ -f /opt/asdf/asdf.sh ]; then
  source /opt/asdf/asdf.sh
fi

asdf install

set -eu

# Do not prompt when pnpm needs to purge node_modules (fails on non-TTY runs)
npx pnpm --config.confirmModulesPurge=false install

if [ -d bin ]; then
  rm -r bin
fi

if [ ! -d bin ]; then
  mkdir bin
fi

for bin_file in node_modules/.bin/*; do
  [ -e "$bin_file" ] || continue
  cp bin_templ "bin/$(basename "$bin_file")"
done

popd >>/dev/null

echo "install completed"
