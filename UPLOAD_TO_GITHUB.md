# GitHub 上传指南

## 🚀 快速上传（3 步完成）

### 步骤 1：创建 GitHub 仓库

1. 访问 https://github.com
2. 登录/注册账号
3. 点击右上角 "+" → "New repository"
4. 填写：
   - Repository name: `video-cleaner-app`
   - Description: `视频素材清理助手 - 自动清理已发布视频号的原始素材`
   - Visibility: **Public**（公开）
   - 不要勾选 "Initialize this repository with a README"
5. 点击 "Create repository"

### 步骤 2：上传代码（2 种方式任选）

#### 方式 A：网页上传（最简单，推荐新手）

1. 在创建的仓库页面，点击 "uploading an existing file"
2. 打开文件管理器，进入项目目录：
   ```
   /home/admin/openclaw/workspace/video-cleaner-app/
   ```
3. 选择以下文件和文件夹拖拽到网页：
   - `.github/`
   - `assets/`
   - `docs/`
   - `lib/`
   - `.gitignore`
   - `BUILD_APK.md`
   - `CHECKLIST.md`
   - `DELIVERY.md`
   - `PROJECT_SUMMARY.md`
   - `pubspec.yaml`
   - `QUICK_START.md`
   - `README.md`

4. 在 "Commit changes" 输入框填写：`Initial commit`
5. 点击 "Commit changes"

#### 方式 B：Git 命令行（推荐有 Git 经验的用户）

```bash
# 1. 进入项目目录
cd /home/admin/openclaw/workspace/video-cleaner-app

# 2. 初始化 Git
git init

# 3. 添加所有文件
git add .

# 4. 提交
git commit -m "Initial commit - 视频素材清理助手 v0.1"

# 5. 关联远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/video-cleaner-app.git

# 6. 推送
git branch -M main
git push -u origin main
```

### 步骤 3：自动构建 APK

1. 代码上传后，访问仓库的 "Actions" 标签页
2. 你会看到 "Build APK" 工作流正在运行
3. 等待约 5-10 分钟，构建完成后：
   - 点击运行的工作流
   - 在页面底部找到 "artifacts" 区域
   - 点击 `app-release` 下载 APK

---

## 📥 下载 APK（给他人使用）

### 方式 1：GitHub Releases（推荐）

如果你创建了 tag（如 v1.0.0）：
1. 访问 `https://github.com/YOUR_USERNAME/video-cleaner-app/releases`
2. 下载最新版本的 APK

### 方式 2：GitHub Actions

1. 访问 `https://github.com/YOUR_USERNAME/video-cleaner-app/actions`
2. 点击最新的构建
3. 下载 artifacts 中的 APK

### 方式 3：直接下载（适合测试）

1. 访问仓库
2. 点击任意文件
3. 点击 "Raw" 按钮
4. 但这不适合下载 APK（APK 在构建产物中）

---

## 🏷️ 创建 Release 版本

```bash
# 1. 打标签
git tag v1.0.0

# 2. 推送标签
git push origin v1.0.0

# 这会自动触发 GitHub Actions 创建 Release
```

然后在 GitHub 仓库的 "Releases" 页面可以下载 APK。

---

## 📱 分享 APK 给他人

### 方式 1：GitHub 链接
直接分享仓库链接：
```
https://github.com/YOUR_USERNAME/video-cleaner-app
```

### 方式 2：下载链接
分享 Actions 中的 APK 下载链接（需要登录 GitHub）

### 方式 3：网盘分享
1. 下载 APK 到本地
2. 上传到百度网盘/阿里云盘
3. 分享链接给他人

---

## ⚙️ 自定义构建配置

如需修改 Flutter 版本，编辑 `.github/workflows/build-apk.yml`:

```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.16.0'  # 修改版本号
    channel: 'stable'
```

---

## 🔐 安全提示

1. **不要提交敏感信息**
   - API 密钥
   - 签名文件（.jks, .keystore）
   - 密码

2. **发布签名（可选）**
   如果要上架应用商店，需要签名：
   ```bash
   # 创建签名文件
   keytool -genkey -v -keystore my-release-key.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias my-alias
   ```
   
   **不要将签名文件上传到 GitHub！**

---

## 📞 需要帮助？

如果在上传过程中遇到问题：
1. 截图错误信息
2. 告诉我具体步骤
3. 我会帮你解决

---

*最后更新：2026-03-16*
