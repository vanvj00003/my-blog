#!/bin/bash

set -e

REPO_DIR="${PWD}"
GH_TOKEN="${GH_TOKEN:-}"
if [ -z "$GH_TOKEN" ]; then
    echo "错误: GH_TOKEN 环境变量未设置"
    echo "使用方法: GH_TOKEN=your_token bash deploy.sh"
    exit 1
fi
REMOTE_URL="https://vanvj00003:${GH_TOKEN}@github.com/vanvj00003/my-blog.git"

echo "=========================================="
echo "发布博客到 https://vanvj00003.github.io/my-blog/"
echo "=========================================="

cd "$REPO_DIR"

# Clean build
echo "[1/3] 清理旧构建..."
rm -rf public resources/_gen

# Build
echo "[2/3] 构建博客..."
hugo --minify

# Deploy to gh-pages
echo "[3/3] 推送到 gh-pages..."

# Create a temporary directory for gh-pages
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Clone gh-pages branch
git clone -b gh-pages "$REMOTE_URL" "$TEMP_DIR" 2>/dev/null || git clone "$REMOTE_URL" "$TEMP_DIR"

# Remove all files except .git
cd "$TEMP_DIR"
find . -maxdepth 1 ! -name ".git" -delete

# Copy new files
cp -r "$REPO_DIR/public/"* "$TEMP_DIR/"

# Commit and push
git add -A
git commit -m "Deploy: $(date '+%Y-%m-%d %H:%M:%S')" || true
git push "$REMOTE_URL" gh-pages

echo "=========================================="
echo "发布完成！"
echo "博客地址：https://vanvj00003.github.io/my-blog/"
echo "=========================================="
