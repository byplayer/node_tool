#!/bin/bash

pushd $(dirname ${0}) >/dev/null
BASE_DIR=$(pwd)
popd >/dev/null

pushd $BASE_DIR >>/dev/null

type brew >/dev/null
if [ $? -eq 0 ]; then
  source $(brew --prefix asdf)/libexec/asdf.sh
else
  source /opt/asdf/asdf.sh
fi

set -eu

yarn install

if [ -d bin ]; then
  rm -r bin
fi

if [ ! -d bin ]; then
  mkdir bin
fi

for bin_file in $(\ls node_modules/.bin); do
  cp bin_templ bin/$bin_file
done

popd >>/dev/null

echo "install completed"
