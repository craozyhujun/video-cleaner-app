# 快速启动指南

## 环境准备

### 1. 安装 Flutter SDK

#### macOS
```bash
# 使用 Homebrew 安装
brew install --cask flutter

# 或手动安装
# 1. 下载 Flutter SDK: https://docs.flutter.dev/get-started/install/macos
# 2. 解压到 ~/development/flutter
# 3. 添加到 PATH
export PATH="$PATH:$HOME/development/flutter/bin"
```

#### Windows
```powershell
# 1. 下载 Flutter SDK: https://docs.flutter.dev/get-started/install/windows
# 2. 解压到 C:\src\flutter
# 3. 添加到系统 PATH
# 4. 运行 flutter doctor
```

#### Linux
```bash
# 使用 Snap 安装
sudo snap install flutter --classic

# 或手动安装
# 1. 下载 Flutter SDK
# 2. 解压到 ~/development/flutter
# 3. 添加到 PATH
export PATH="$PATH:$HOME/development/flutter/bin"
```

### 2. 安装开发工具

#### macOS (iOS 开发必需)
```bash
# 安装 Xcode (App Store)
# 安装 Xcode 命令行工具
xcode-select --install

# 安装 CocoaPods
sudo gem install cocoapods
```

#### Android (全平台必需)
```bash
# 下载 Android Studio: https://developer.android.com/studio
# 安装后配置 Android SDK
# 在 Flutter 中运行：
flutter doctor --android-licenses
```

#### VS Code 插件
- Flutter
- Dart

### 3. 验证安装

```bash
# 检查 Flutter 安装
flutter doctor

# 应该看到类似输出：
# Doctor summary (to see all details, run flutter doctor -v):
# [✓] Flutter (Channel stable, 3.16.x, on macOS 14.x)
# [✓] Android toolchain - develop for Android devices
# [✓] Xcode - develop for iOS and macOS
# [✓] Chrome - develop for the web
# [✓] Android Studio
# [✓] VS Code
# [✓] Connected device
# [✓] Network resources
```

---

## 运行项目

### 1. 进入项目目录
```bash
cd ~/.openclaw/workspace/video-cleaner-app
```

### 2. 安装依赖
```bash
flutter pub get
```

### 3. 运行项目

#### Android
```bash
# 确保 Android 模拟器已启动或连接真机
flutter run

# 或指定设备
flutter run -d <device-id>

# 查看可用设备
flutter devices
```

#### iOS (macOS only)
```bash
# 确保 iOS 模拟器已启动或连接真机
flutter run -d ios

# 或使用 Xcode 运行
open ios/Runner.xcworkspace
```

### 4. 构建 Release 版本

#### Android APK
```bash
flutter build apk --release

# 输出位置：build/app/outputs/flutter-apk/app-release.apk
```

#### Android App Bundle (Google Play)
```bash
flutter build appbundle --release

# 输出位置：build/app/outputs/bundle/release/app-release.aab
```

#### iOS (macOS only)
```bash
flutter build ios --release

# 输出位置：build/ios/iphoneos/Runner.app
# 需要通过 Xcode Archive 并上传到 App Store
```

---

## 常见问题

### Q1: flutter doctor 显示 Android license status unknown
```bash
flutter doctor --android-licenses
# 全部选择 y 接受
```

### Q2: iOS 编译失败
```bash
# 清理构建缓存
flutter clean
flutter pub get

# 重新构建 iOS
cd ios
pod install
cd ..
flutter build ios
```

### Q3: 权限问题（Android）
确保 `android/app/src/main/AndroidManifest.xml` 包含以下权限：
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.CAMERA"/>
```

### Q4: 权限问题（iOS）
确保 `ios/Runner/Info.plist` 包含以下描述：
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册以管理视频素材</string>
<key>NSCameraUsageDescription</key>
<string>需要访问相机以拍摄视频</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>需要保存视频到相册</string>
```

---

## 开发建议

### 热重载
开发时使用热重载加快迭代：
- 保存文件自动热重载（VS Code）
- 或按 `r` 键手动热重载
- 按 `R` 键热重启

### 调试
```bash
# 查看日志
flutter logs

# 或运行中按 p 键显示性能叠加层
```

### 测试
```bash
# 运行测试
flutter test

# 带覆盖率
flutter test --coverage
```

---

## 下一步

1. **运行项目** - 确保能在模拟器/真机上运行
2. **测试核心功能** - 访问相册、视频列表、清理功能
3. **UI 优化** - 根据需求调整界面
4. **接入视频号** - 实现发布状态识别（需进一步开发）
5. **测试上架** - 准备应用商店材料

---

## 项目结构说明

```
video-cleaner-app/
├── lib/
│   ├── main.dart              # 入口文件
│   ├── config/                # 配置（路由、主题）
│   ├── models/                # 数据模型
│   ├── providers/             # 状态管理
│   ├── services/              # 业务服务
│   └── views/                 # 页面
│       ├── home/              # 首页
│       ├── clean/             # 清理页
│       ├── settings/          # 设置页
│       └── records/           # 记录页
├── android/                   # Android 配置
├── ios/                       # iOS 配置
├── assets/                    # 资源文件
├── pubspec.yaml              # 依赖配置
└── README.md                 # 本文件
```

---

## 技术支持

遇到问题时：
1. 查看 Flutter 官方文档：https://docs.flutter.dev
2. 搜索 Flutter GitHub Issues: https://github.com/flutter/flutter/issues
3. Stack Overflow: https://stackoverflow.com/questions/tagged/flutter

---

*最后更新：2026-03-16*
