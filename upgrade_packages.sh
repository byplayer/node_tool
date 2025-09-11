#!/bin/bash

yarn upgrade --latest

if [[ -z $(git status --porcelain) ]]; then
    echo "✅ No changes to commit. Exiting."
    exit 0
fi

git switch -c "update_packages_$(date +"%Y%m%d%H%M%S")"

git add .
git commit -m "⬆️ upgrade packages"

if ! git ls-remote --exit-code --heads origin "$(git branch --show-current)" &>/dev/null; then
    git push --set-upstream origin "$(git branch --show-current)"
else
    git push
fi

gh pr create --title "⬆️ upgrade packages" --body "Automated package upgrade via \`update_packages.sh\` script."
echo "✅ Changes committed and PR created."
