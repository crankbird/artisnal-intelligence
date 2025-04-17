#!/bin/zsh
# setup-remotes.sh – Configure Git remotes and tracking branches

set -e

echo "🔧 Renaming origin → dev..."
git remote rename origin dev

echo "🔧 Adding prod remote..."
git remote add prod https://github.com/crankbird/artisanal-intelligence.info.git
git fetch --all

echo "🔁 Setting upstream for dev-main..."
git branch --set-upstream-to=dev/dev-main dev-main

echo "🚀 Checking out prod-main from prod..."
git checkout -B prod-main prod/prod-main
git branch --set-upstream-to=prod/prod-main prod-main

git checkout dev-main
echo "✅ Setup complete: remotes and branches are synced."
