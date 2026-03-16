#!/bin/bash

# 视频素材清理助手 - 打包脚本
# 使用方法：bash package.sh

set -e

PROJECT_DIR="/home/admin/openclaw/workspace/video-cleaner-app"
OUTPUT_DIR="/home/admin/openclaw/workspace/video-cleaner-app-dist"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "🚀 开始打包视频素材清理助手..."
echo "📁 项目目录：$PROJECT_DIR"
echo "📦 输出目录：$OUTPUT_DIR"

# 创建输出目录
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# 复制文件
echo "📋 复制文件..."
cp -r "$PROJECT_DIR/.github" "$OUTPUT_DIR/"
cp -r "$PROJECT_DIR/assets" "$OUTPUT_DIR/"
cp -r "$PROJECT_DIR/docs" "$OUTPUT_DIR/"
cp -r "$PROJECT_DIR/lib" "$OUTPUT_DIR/"
cp "$PROJECT_DIR/.gitignore" "$OUTPUT_DIR/"
cp "$PROJECT_DIR/BUILD_APK.md" "$OUTPUT_DIR/"
cp "$PROJECT_DIR/CHECKLIST.md" "$OUTPUT_DIR/"
cp "$PROJECT_DIR/DELIVERY.md" "$OUTPUT_DIR/"
cp "$PROJECT_DIR/PROJECT_SUMMARY.md" "$OUTPUT_DIR/"
cp "$PROJECT_DIR/pubspec.yaml" "$OUTPUT_DIR/"
cp "$PROJECT_DIR/QUICK_START.md" "$OUTPUT_DIR/"
cp "$PROJECT_DIR/README.md" "$OUTPUT_DIR/"
cp "$PROJECT_DIR/UPLOAD_TO_GITHUB.md" "$OUTPUT_DIR/"
cp "$PROJECT_DIR/package.sh" "$OUTPUT_DIR/"

# 创建 ZIP 压缩包
echo "🗜️ 创建 ZIP 压缩包..."
cd /home/admin/openclaw/workspace
zip -r "video-cleaner-app-$TIMESTAMP.zip" video-cleaner-app-dist/

echo ""
echo "✅ 打包完成！"
echo ""
echo "📦 压缩包位置："
echo "   /home/admin/openclaw/workspace/video-cleaner-app-$TIMESTAMP.zip"
echo ""
echo "📁 解压后目录："
echo "   $OUTPUT_DIR"
echo ""
echo "🚀 下一步："
echo "   1. 下载 ZIP 文件到本地"
echo "   2. 按照 BUILD_APK.md 构建 APK"
echo "   3. 或按照 UPLOAD_TO_GITHUB.md 上传到 GitHub"
echo ""
