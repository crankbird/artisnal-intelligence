#!/bin/bash

# ============================================================================
# Script: add-blog-repo.sh
# Description:
#   Adds a GitHub-based blog repo to a local directory.
#   Supports shared or isolated repo setups.
#   Validates Ruby, Bundler, and Jekyll dependencies.
#   Offers to patch Gemfile with bigdecimal if needed (Ruby 3.4+)
# ============================================================================

set -e

usage() {
  echo ""
  echo "┌────────────────────────────────────────────┐"
  echo "│     🚀 Blog Setup Utility (Bash)           │"
  echo "└────────────────────────────────────────────┘"
  echo ""
  echo "Usage:"
  echo "  $0 <remote-name> <repo-url> <branch-name> <target-dir> [--no-test-harness]"
  echo ""
  echo "Arguments:"
  echo "  remote-name     Name to assign to the Git remote (e.g., artisanal)"
  echo "  repo-url        SSH GitHub repo URL (e.g., git@github.com:you/project.git)"
  echo "  branch-name     Name of the remote branch to track (e.g., artisanal-main)"
  echo "  target-dir      Local directory to use or create"
  echo ""
  echo "Options:"
  echo "  --no-test-harness   Skip Ruby/Bundler/Jekyll checks and bundle install"
  echo "  -h, --help          Show this help message and exit"
  echo ""
  echo "Examples:"
  echo "  $0 artisanal git@github.com:crankbird/artisanal-intelligence.info.git artisanal-main ~/blogs/artisanal"
  echo "  $0 crankbird git@github.com:crankbird/crankbird.com.git crankbird-main ~/blogs/crank-dev --no-test-harness"
  echo ""
  exit 0
}

# --------------------------
# Parse arguments
# --------------------------

# Check for help flag first

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  usage
fi

# Check argument count

if [ $# -lt 4 ]; then
  usage
fi

REMOTE_NAME="$1"
REPO_URL="$2"
BRANCH_NAME="$3"
TARGET_DIR="$4"
SKIP_HARNESS=false

if [[ "$5" == "--no-test-harness" ]]; then
  SKIP_HARNESS=true
fi


# --------------------------
# Prerequisite check
# --------------------------
check_prereqs() {
  for cmd in ruby bundle; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "❌ Required command '$cmd' not found. Please install it."
      exit 1
    fi
  done

  if [ -f "Gemfile.lock" ]; then
    if grep -q 'jekyll' Gemfile.lock; then
      echo "✅ Jekyll found in Gemfile.lock (via bundle exec)"
    else
      echo "⚠️  Jekyll not listed in Gemfile.lock. You may need to add it to your Gemfile."
    fi
  else
    echo "⚠️  No Gemfile.lock found. Assuming you’ll run 'bundle install' shortly..."
  fi
}

# --------------------------
# Main logic
# --------------------------
echo "📁 Target directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || exit 1

if [ -d ".git" ]; then
  echo "🔁 Existing Git repo detected (shared mode)"
else
  echo "📥 Cloning $REPO_URL into $(pwd)"
  git clone "$REPO_URL" . --origin "$REMOTE_NAME"
fi

# Add remote if not already present
if git remote get-url "$REMOTE_NAME" >/dev/null 2>&1; then
  echo "ℹ️  Remote '$REMOTE_NAME' already exists — skipping add"
else
  echo "➕ Adding remote '$REMOTE_NAME'"
  git remote add "$REMOTE_NAME" "$REPO_URL"
fi

echo "🔄 Fetching from '$REMOTE_NAME'..."
git fetch "$REMOTE_NAME"

# Create and track branch if it doesn't exist
if git show-ref --quiet refs/heads/"$BRANCH_NAME"; then
  echo "✅ Branch '$BRANCH_NAME' already exists locally"
else
  echo "🌱 Creating branch '$BRANCH_NAME' from '$REMOTE_NAME/$BRANCH_NAME'"
  git checkout -b "$BRANCH_NAME" "$REMOTE_NAME/$BRANCH_NAME"
fi

# --------------------------
# Test harness + Gemfile
# --------------------------
if [ "$SKIP_HARNESS" = false ]; then
  echo "🔍 Checking Jekyll dependencies..."
  check_prereqs

  if [ -f "Gemfile" ]; then
    if ! grep -qE 'gem\s+["'\'']bigdecimal["'\'']' Gemfile; then
      echo "⚠️  'bigdecimal' not found in Gemfile."
      read -rp "Do you want to add it now? [y/N]: " add_bigdecimal
      if [[ "$add_bigdecimal" =~ ^[Yy]$ ]]; then
        echo 'gem "bigdecimal"' >> Gemfile
        echo "✅ Added 'gem \"bigdecimal\"' to Gemfile"
      else
        echo "ℹ️  Skipping. You may need to add 'gem \"bigdecimal\"' manually if using Ruby 3.4+"
      fi
    fi

    echo "📦 Running bundle install..."
    bundle install
    echo ""
    echo "💡 Test harness ready!"
    echo "👉 To preview your site, run:"
    echo "   cd \"$TARGET_DIR\" && bundle exec jekyll serve"
    echo "🌐 Then visit: http://localhost:4000"
  else
    echo "⚠️  No Gemfile found — skipping bundle install"
  fi
else
  echo "🚫 Test harness skipped due to --no-test-harness flag"
fi

echo ""
echo "✅ Done! Branch '$BRANCH_NAME' is ready in: $TARGET_DIR"
