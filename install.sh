#!/bin/bash

NVM_VER=v0.37.2

pushd `dirname ${0}` > /dev/null
BASE_DIR=`pwd`
popd > /dev/null


pushd $BASE_DIR >> /dev/null


if [ ! -d .nvm ]; then
  git clone https://github.com/creationix/nvm.git .nvm
fi

pushd .nvm >> /dev/null
git pull
git checkout $NVM_VER
popd >> /dev/null

export NVM_DIR=${BASE_DIR}/.nvm
source ${NVM_DIR}/nvm.sh

# install node if ncessary
NODE_VER=$(cat .nvmrc| head -1)
nvm ls ${NODE_VER}
result=$?

if [ $result -ne 0 ]; then
  nvm install $(cat .nvmrc| head -1)
fi

nvm use

set -ex

npm install -g yarn

nvm use

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

popd >> /dev/null

echo "install completed"
