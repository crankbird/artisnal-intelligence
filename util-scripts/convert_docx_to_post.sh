#!/bin/bash

# A script to convert a Word (.docx) file into a Jekyll-compatible Markdown post
# Extracts embedded images, relocates them to the assets folder, updates image links, and injects Jekyll front matter

set -e

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <input.docx> <jekyll-blog-root-dir> [post-slug]"
  exit 1
fi

INPUT_DOCX="$1"
JEKYLL_ROOT="$2"
POST_SLUG="$3"

# Default slug = lowercase, dashed, sanitized basename of the .docx file
if [ -z "$POST_SLUG" ]; then
  POST_SLUG=$(basename "$INPUT_DOCX" .docx | iconv -c -t ascii//TRANSLIT | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]\+/-/g' | sed 's/-$//')
fi

MEDIA_DIR="$POST_SLUG/media"
TEMP_DIR="/tmp/pandoc-test"
mkdir -p "$TEMP_DIR"
DATE=$(date +%Y-%m-%d)
POST_FILENAME="$DATE-$POST_SLUG.md"
MD_OUTPUT="$TEMP_DIR/$POST_FILENAME"

# Step 1: Convert DOCX to HTML first
pandoc "$INPUT_DOCX" \
  --extract-media="$TEMP_DIR/$MEDIA_DIR" \
  -t html \
  -o "$TEMP_DIR/intermediate.html"

# Step 2: Convert HTML to Markdown with raw HTML preserved (especially for tables)
pandoc "$TEMP_DIR/intermediate.html" \
  -f html \
  -t gfm-pipe_tables\
  -o "$MD_OUTPUT"

# Step 3: Copy media to assets/images/<slug>/
ASSETS_TARGET="$JEKYLL_ROOT/assets/images/$POST_SLUG"
mkdir -p "$ASSETS_TARGET"
cp -r "$TEMP_DIR/$MEDIA_DIR" "$ASSETS_TARGET/" 2>/dev/null || true

# Step 4: Update image paths in Markdown
# Replace any absolute /tmp/... style paths with the correct Jekyll path
sed -i "s#\(/tmp[^)]*\)/$MEDIA_DIR/#/assets/images/$POST_SLUG/media/#g" "$MD_OUTPUT"
# Also clean up any {width=...} or {height=...} annotations
sed -i 's/{[^}]*}//g' "$MD_OUTPUT"

# Step 5: Choose default card image
DEFAULT_IMAGE="/assets/images/logo.png"
FIRST_IMAGE=$(grep -o "/assets/images/$POST_SLUG/media/[^)]*" "$MD_OUTPUT" | head -n 1)
SELECTED_IMAGE="${FIRST_IMAGE:-$DEFAULT_IMAGE}"

# Step 6: Prepend Jekyll front matter
TMP_WITH_FRONT_MATTER="$TEMP_DIR/tmp_$POST_FILENAME"
cat > "$TMP_WITH_FRONT_MATTER" <<EOF
---
title: "$POST_SLUG"
date: $DATE
author: Your Name # Replace with your actual name or handle
layout: post
description: "" # Optional description for SEO
category: [category1, category2] # List of categories, used by SEO plugins
tags: [tag1, tag2] # Optional tags for grouping content
image: $SELECTED_IMAGE # Default image used in previews or cards
---

EOF

cat "$MD_OUTPUT" >> "$TMP_WITH_FRONT_MATTER"
POST_OUTPUT="$JEKYLL_ROOT/_posts/$POST_FILENAME"
mv "$TMP_WITH_FRONT_MATTER" "$POST_OUTPUT"

# Step 6: Add README to image directory
cat > "$ASSETS_TARGET/README.md" <<EOF
# $POST_SLUG — Image Metadata

This folder contains images extracted from:
- Source: \`$INPUT_DOCX\`
- Post: \`_posts/$POST_FILENAME\`
- Extracted on: $(date)

EOF

echo "✔️ Converted '$INPUT_DOCX' to Jekyll post: $POST_OUTPUT"
echo "🖼️ Images placed in: $ASSETS_TARGET"
echo "🧩 Card image used: $SELECTED_IMAGE"
echo "📌 Remember to review the front matter and update title, categories, etc."

