#!/bin/bash

git switch -c update_packages_$(date +"%Y%m%d%H%M%S")

yarn upgrade --latest

git add .
git commit -m "⬆️ upgrade packages"
git ex push
