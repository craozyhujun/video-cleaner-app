# APK 构建与安装指南

## 🎯 三种获取 APK 的方案

### 方案一：本地构建（推荐）⭐

**优点**：完全控制，可修改代码
**缺点**：需要安装 Flutter 环境

#### 步骤 1：安装 Flutter

**Windows:**
```powershell
# 1. 下载 Flutter SDK
# https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.16.0-stable.zip

# 2. 解压到 C:\src\flutter

# 3. 添加到系统 PATH
# 右键"此电脑" → 属性 → 高级系统设置 → 环境变量
# 在 Path 中添加 C:\src\flutter\bin

# 4. 重启终端，验证
flutter doctor
```

**macOS:**
```bash
# 使用 Homebrew
brew install --cask flutter

# 或手动安装
# 1. 下载：https://docs.flutter.dev/get-started/install/macos
# 2. 解压到 ~/development/flutter
# 3. 编辑 ~/.zshrc 或 ~/.bash_profile
export PATH="$PATH:$HOME/development/flutter/bin"
# 4. 生效
source ~/.zshrc

# 5. 验证
flutter doctor
```

**Linux:**
```bash
# 使用 Snap
sudo snap install flutter --classic

# 验证
flutter doctor
```

#### 步骤 2：安装 Android Studio

**Windows/macOS/Linux:**
1. 下载：https://developer.android.com/studio
2. 安装后打开 Android Studio
3. 安装 Android SDK（默认已包含）
4. 接受许可证：
   ```bash
   flutter doctor --android-licenses
   # 全部输入 y 接受
   ```

#### 步骤 3：构建 APK

```bash
# 1. 进入项目目录
cd video-cleaner-app

# 2. 安装依赖
flutter pub get

# 3. 构建 Release APK
flutter build apk --release

# 输出位置：
# build/app/outputs/flutter-apk/app-release.apk
```

#### 步骤 4：传输到手机

**方式 A：USB 传输**
1. 手机连接电脑
2. 复制 `app-release.apk` 到手机
3. 在手机上安装

**方式 B：微信/QQ 发送**
1. 通过微信/QQ 文件传输助手发送 APK
2. 在手机上下载安装

**方式 C：网盘分享**
1. 上传 APK 到百度网盘/阿里云盘
2. 手机下载并安装

#### 步骤 5：安装 APK

**Android 手机:**
1. 允许"安装未知来源应用"
2. 打开 APK 文件安装
3. 授权相册权限

---

### 方案二：GitHub 托管 + 在线构建

**优点**：代码有备份，可协作
**缺点**：需要 GitHub 账号

#### 步骤 1：创建 GitHub 仓库

1. 访问 https://github.com
2. 登录/注册账号
3. 点击 "+" → "New repository"
4. 名称：`video-cleaner-app`
5. 选择 "Public"
6. 点击 "Create repository"

#### 步骤 2：上传代码

**方式 A：网页上传（简单）**
1. 在仓库页面点击 "uploading an existing file"
2. 拖拽项目所有文件
3. 点击 "Commit changes"

**方式 B：Git 命令行**
```bash
cd video-cleaner-app

# 初始化 Git
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit"

# 关联远程仓库（替换 YOUR_USERNAME）
git remote add origin https://github.com/YOUR_USERNAME/video-cleaner-app.git

# 推送
git push -u origin main
```

#### 步骤 3：使用 GitHub Actions 自动构建 APK

在项目根目录创建 `.github/workflows/build.yml`:

```yaml
name: Build APK

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: app-release
        path: build/app/outputs/flutter-apk/app-release.apk
```

推送后，在 GitHub 仓库的 "Actions" 标签页下载 APK。

---

### 方案三：远程协助（最省心）

**优点**：无需自己操作
**缺点**：需要信任第三方

#### 选项 A：找本地开发者
- 在猪八戒网/程序员客栈等平台找 Flutter 开发者
- 费用：约 200-500 元（一次性构建）

#### 选项 B：使用在线构建服务
- **Codemagic**: https://codemagic.io/
  - 免费额度：500 构建分钟/月
  - 连接 GitHub 后自动构建
  
- **Bitrise**: https://www.bitrise.io/
  - 免费额度：100 构建/月
  - 支持 Flutter

---

## 📱 安装后测试清单

### 基础功能测试
- [ ] App 能否正常启动
- [ ] 相册权限授权
- [ ] 视频列表是否正常显示
- [ ] 存储概览数据是否正确

### 清理功能测试
- [ ] 选择视频
- [ ] 执行清理
- [ ] 回收站文件查看
- [ ] 清理记录查看

### 设置测试
- [ ] 修改清理模式
- [ ] 修改回收站天数
- [ ] 开关通知

### 问题反馈
如遇到问题，记录以下信息：
1. 手机型号
2. Android 版本
3. 问题描述
4. 截图/录屏

---

## 🔧 常见问题

### Q1: flutter doctor 显示 Android license 未接受
```bash
flutter doctor --android-licenses
# 全部输入 y
```

### Q2: 构建失败 - Gradle 错误
```bash
# 清理后重试
flutter clean
flutter pub get
flutter build apk --release
```

### Q3: APK 安装失败 - 解析包错误
- 检查 Android 版本（需 Android 5.0+）
- 检查 APK 是否完整下载
- 尝试重新构建

### Q4: App 闪退 - 权限问题
- 确保在 AndroidManifest.xml 中添加权限
- 首次启动时授权相册权限

---

## 📞 需要帮助？

如果你在构建过程中遇到任何问题，请告诉我：
1. 使用的操作系统
2. 遇到的具体错误信息
3. 截图或错误日志

我会帮你解决！

---

*最后更新：2026-03-16*
