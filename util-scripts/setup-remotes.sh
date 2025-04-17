#!/bin/zsh
# setup-remotes.sh – Configure Git remotes and tracking branches

set -e

echo "🔧 Renaming origin → dev..."
git remote rename origin dev

echo "🔧 Adding prod remote..."
git remote add prod https://github.com/crankbird/artisanal-intelligence.info.git

echo "🔄 Fetching all remote branches..."
git fetch --all

echo "🔁 Setting upstream for dev-main..."
git branch --set-upstream-to=dev/dev-main dev-main

if git show-ref --verify --quiet refs/remotes/prod/prod-main; then
  echo "🚀 Checking out local prod-main tracking prod/prod-main..."
  git checkout -B prod-main prod/prod-main
  git branch --set-upstream-to=prod/prod-main prod-main
else
  echo "⚠️  prod/prod-main not found. You may need to push it manually first."
fi

echo "🔙 Switching back to dev-main..."
git checkout dev-main

echo "✅ Setup complete: remotes and branches are synced."
