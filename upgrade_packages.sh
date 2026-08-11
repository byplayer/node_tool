#!/bin/bash

# --latest でメジャーバージョンも含めて更新する (pnpm 自身も dependencies に含まれる)
pnpm update --latest

# dependencies の pnpm に合わせて packageManager フィールドも更新する
pnpm_version=$(node -p "require('./node_modules/pnpm/package.json').version")
if [[ -n "$pnpm_version" ]]; then
    pnpm pkg set "packageManager=pnpm@${pnpm_version}"
    echo "📦 packageManager: pnpm@${pnpm_version}"
else
    echo "⚠️  Failed to detect installed pnpm version. Skipping packageManager update."
fi

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

pr_url=$(gh pr create --title "⬆️ upgrade packages" --body "Automated package upgrade via \`update_packages.sh\` script." | grep -o 'https://github.com/[^ ]*')
if [[ -n "$pr_url" ]]; then
    open "$pr_url"
else
    echo "❌ Failed to retrieve PR URL."
fi

echo "✅ Changes committed and PR created."
