# 项目启动检查清单

## 📋 启动前准备

### 1. 环境准备
- [ ] 安装 Flutter SDK (3.16+)
- [ ] 安装 Xcode (iOS 开发，macOS 必需)
- [ ] 安装 Android Studio (Android 开发)
- [ ] 配置 Android SDK 和模拟器
- [ ] 配置 iOS 模拟器或真机
- [ ] 安装 VS Code + Flutter 插件

### 2. 账号准备
- [ ] Apple Developer 账号 ($99/年)
- [ ] Google Play Console 账号 ($25 一次性)
- [ ] 华为开发者账号 (免费)
- [ ] 小米开发者账号 (免费)
- [ ] OPPO/VIVO 开发者账号 (免费)
- [ ] 应用宝开发者账号 (免费)

### 3. 设计资源
- [ ] App 图标设计 (1024x1024)
- [ ] 应用商店截图 (多尺寸)
- [ ] 宣传图/海报
- [ ] UI 设计稿 (Figma/Sketch)

### 4. 法律合规
- [ ] 隐私政策文档
- [ ] 用户协议
- [ ] 软件著作权申请 (可选)
- [ ] ICP 备案 (国内上架需要)

### 5. 技术准备
- [ ] GitHub/GitLab 仓库创建
- [ ] 代码规范制定
- [ ] CI/CD 流程配置 (可选)
- [ ] 崩溃监控接入 (Bugly/Sentry)
- [ ] 数据统计接入 (Firebase/友盟)

---

## 🚀 快速启动命令

```bash
# 1. 创建 Flutter 项目
flutter create --org com.videocleaner video_cleaner_app

# 2. 进入项目目录
cd video_cleaner_app

# 3. 安装依赖
flutter pub get

# 4. 运行代码检查
flutter analyze

# 5. 运行测试
flutter test

# 6. 运行 iOS (macOS)
flutter run -d ios

# 7. 运行 Android
flutter run -d android

# 8. 构建 Release 版本
flutter build apk --release
flutter build ios --release
```

---

## 📁 推荐项目结构

```
video_cleaner_app/
├── docs/                    # 文档
│   ├── PRD.md
│   ├── TECHNICAL_DESIGN.md
│   ├── DEVELOPMENT_PLAN.md
│   └── meetings/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── config/
│   ├── models/
│   ├── providers/
│   ├── services/
│   ├── utils/
│   └── views/
├── test/
├── assets/
├── android/
├── ios/
├── pubspec.yaml
├── README.md
└── CHECKLIST.md (本文件)
```

---

## 📊 关键决策记录

| 决策项 | 决策内容 | 决策时间 | 决策人 |
|--------|----------|----------|--------|
| 技术栈 | Flutter 跨平台 | 2026-03-16 | 用户 |
| 清理模式 | 用户可配置 (手动/半自动/全自动) | 2026-03-16 | 用户 |
| 存储策略 | 先本地清理，后续扩展云存储 | 2026-03-16 | 用户 |
| 变现策略 | MVP 优先，二期接入广告 | 2026-03-16 | 用户 |
| 发布渠道 | 官方商店 + 第三方渠道 | 2026-03-16 | 用户 |

---

## ⚠️ 已知风险与待办

### 高风险
1. **视频号 API 限制** - 微信未开放官方 API，需采用手动标记或无障碍服务
   - 负责人：待确认
   - 解决期限：Week 2 前确定方案

2. **iOS 后台限制** - 全自动模式在 iOS 上可能无法实现
   - 负责人：待确认
   - 解决期限：Week 2 前评估可行性

### 中风险
3. **应用商店审核** - 清理类 App 审核较严格
   - 负责人：待确认
   - 解决期限：Week 6 前准备材料

4. **用户误删** - 可能导致用户数据丢失投诉
   - 负责人：待确认
   - 解决期限：Week 4 前实现回收站机制

### 待确认事项
- [ ] 开发团队人员确定
- [ ] 项目开始日期确定
- [ ] UI 设计资源确定 (自建/外包)
- [ ] 测试设备清单确定
- [ ] 预算审批

---

## 📞 联系方式

| 角色 | 姓名 | 联系方式 | 备注 |
|------|------|----------|------|
| 产品负责人 | 待确认 | - | - |
| 技术负责人 | 待确认 | - | - |
| UI 设计 | 待确认 | - | - |
| 测试负责人 | 待确认 | - | - |

---

*创建时间：2026-03-16*
*最后更新：2026-03-16*
