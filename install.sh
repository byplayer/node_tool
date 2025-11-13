#!/bin/bash

pushd "$(dirname "${0}")" >/dev/null
BASE_DIR=$(pwd)
popd >/dev/null

pushd "$BASE_DIR" >>/dev/null

if type brew >/dev/null 2>&1; then
  source "$(brew --prefix asdf)/libexec/asdf.sh"
fi

if [ -f /opt/asdf/asdf.sh ]; then
  source /opt/asdf/asdf.sh
fi

set -eu

npx pnpm install

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
