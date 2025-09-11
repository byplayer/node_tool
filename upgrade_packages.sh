#!/bin/bash

yarn upgrade --latest

if [[ -z $(git status --porcelain) ]]; then
    echo "✅ No changes to commit. Exiting."
    exit 0
fi

git switch -c "update_packages_$(date +"%Y%m%d%H%M%S")"

git add .
git commit -m "⬆️ upgrade packages"
git ex push
