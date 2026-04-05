#!/bin/bash

set -e

REPO_DIR="${PWD}"
COMMIT_MSG="${1:-deploy: $(date '+%Y-%m-%d %H:%M:%S')}"
REMOTE_URL="https://vanvj00003@github.com/vanvj00003/my-blog.git"
GH_PAGES_BRANCH="gh-pages"

echo "=========================================="
echo "发布博客到 https://vanvj00003.github.io/my-blog/"
echo "=========================================="

cd "$REPO_DIR"

# Clean build
echo "[1/4] 清理旧构建..."
rm -rf public resources/_gen

# Build
echo "[2/4] 构建博客..."
hugo --minify

# Add changes
echo "[3/4] 提交更改..."
git add -A
git commit -m "$COMMIT_MSG" || echo "没有更改需要提交"

# Push to gh-pages
echo "[4/4] 推送到 gh-pages..."
git push ${REMOTE_URL:-origin} ${GH_PAGES_BRANCH}

echo "=========================================="
echo "发布完成！"
echo "博客地址：https://vanvj00003.github.io/my-blog/"
echo "=========================================="
