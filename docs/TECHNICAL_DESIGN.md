# 视频素材清理助手 - 技术方案

## 1. 技术选型

### 1.1 跨平台框架选择

**推荐方案：Flutter**

| 对比项 | Flutter | React Native | 原生开发 |
|--------|---------|--------------|----------|
| 开发效率 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ |
| 性能 | ⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 社区生态 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| 相册访问 | 完善插件 | 完善插件 | 原生 API |
| 后台能力 | 中等 | 中等 | 最强 |
| 上架难度 | 中等 | 中等 | 低 |

**选型理由：**
- 一套代码双端发布，降低开发成本
- 丰富的插件生态（相册、存储、通知等）
- 性能接近原生，用户体验好
- 社区活跃，问题容易解决

### 1.2 技术栈

| 层级 | 技术选型 | 说明 |
|------|----------|------|
| 前端框架 | Flutter 3.x | 跨平台 UI 框架 |
| 状态管理 | Provider / Riverpod | 轻量级状态管理 |
| 本地存储 | Hive / SharedPreferences | 配置存储 |
| 数据库 | SQLite (sqflite) | 清理记录存储 |
| 相册访问 | image_picker + photo_manager | 跨平台相册插件 |
| 文件操作 | path_provider + file | 文件管理 |
| 推送通知 | flutter_local_notifications | 本地通知 |
| 广告 SDK | 穿山甲 (Pangle) / 优量汇 | 二期接入 |
| 云存储 | 阿里云 OSS / 腾讯云 COS | 二期接入 |

### 1.3 开发环境

| 工具 | 版本要求 |
|------|----------|
| Flutter SDK | 3.16+ |
| Dart | 3.2+ |
| Xcode | 15+ (iOS) |
| Android Studio | 2023.1+ (Android) |
| VS Code | 最新稳定版 |

---

## 2. 系统架构

### 2.1 整体架构

```
┌─────────────────────────────────────────────────────────┐
│                      UI Layer                            │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │ 首页    │ │ 清理页  │ │ 设置页  │ │ 记录页  │       │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘       │
├─────────────────────────────────────────────────────────┤
│                   Business Logic Layer                   │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │
│  │ 素材管理器  │ │ 清理引擎    │ │ 配置管理器  │       │
│  └─────────────┘ └─────────────┘ └─────────────┘       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │
│  │ 视频号服务  │ │ 通知服务    │ │ 回收站服务  │       │
│  └─────────────┘ └─────────────┘ └─────────────┘       │
├─────────────────────────────────────────────────────────┤
│                      Data Layer                          │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │ 相册    │ │ 文件系统 │ │ 本地 DB  │ │ 配置    │       │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘       │
└─────────────────────────────────────────────────────────┘
```

### 2.2 核心模块设计

#### 2.2.1 素材管理器 (MediaManager)
```dart
class MediaManager {
  // 获取相册视频列表
  Future<List<MediaFile>> getVideos();
  
  // 根据文件路径查找媒体
  Future<MediaFile?> findByPath(String path);
  
  // 检查文件是否存在
  Future<bool> exists(String path);
  
  // 获取文件大小
  Future<int> getFileSize(String path);
}
```

#### 2.2.2 清理引擎 (CleanEngine)
```dart
class CleanEngine {
  // 执行清理
  Future<CleanResult> clean(List<String> filePaths);
  
  // 移动到回收站
  Future<void> moveToRecycleBin(String filePath);
  
  // 从回收站恢复
  Future<void> restore(String filePath);
  
  // 永久删除
  Future<void> permanentDelete(String filePath);
}
```

#### 2.2.3 视频号服务 (WeChatChannelService)
```dart
class WeChatChannelService {
  // 获取发布记录（需解决 API 限制）
  Future<List<PublishedVideo>> getPublishedVideos();
  
  // 监听发布事件（Android 无障碍服务）
  Stream<PublishedVideo> watchPublishEvents();
  
  // 手动标记已发布
  Future<void> markAsPublished(String mediaPath);
}
```

#### 2.2.4 配置管理器 (ConfigManager)
```dart
class ConfigManager {
  // 获取清理模式
  CleanMode getCleanMode();
  
  // 获取回收站保留天数
  int getRecycleBinDays();
  
  // 获取白名单相册
  List<String> getAlbumWhitelist();
  
  // 更新配置
  Future<void> updateConfig(Config config);
}
```

---

## 3. 关键技术难点与解决方案

### 3.1 难点一：视频号发布状态识别

**问题：** 微信视频号没有开放官方 API 获取发布记录

**解决方案：**

| 方案 | 实现方式 | 优点 | 缺点 | 推荐度 |
|------|----------|------|------|--------|
| 方案 A | 用户手动标记已发布视频 | 实现简单，100% 准确 | 用户体验差 | ⭐⭐⭐ |
| 方案 B | Android 无障碍服务监听发布按钮 | 自动化程度高 | 仅 Android，审核风险 | ⭐⭐⭐⭐ |
| 方案 C | 截图识别发布成功页面 | 跨平台 | 准确率低，体验差 | ⭐⭐ |
| 方案 D | 定期扫描视频号主页（模拟用户操作） | 自动化 | 技术复杂，可能违规 | ⭐⭐ |

**MVP 推荐：方案 A + 方案 B 组合**
- iOS：手动标记（受限于系统）
- Android：无障碍服务 + 手动标记备选

### 3.2 难点二：iOS 后台能力限制

**问题：** iOS 不允许后台长时间运行，全自动模式无法实现

**解决方案：**
- iOS 仅支持手动模式和半自动模式
- 使用 Background Fetch（有限）+ 推送通知
- 在 App 启动时检查并提示可清理素材

### 3.3 难点三：分区存储限制（Android 10+）

**问题：** Android 10+ 采用分区存储，无法直接访问其他 App 文件

**解决方案：**
- 使用 MediaStore API 访问相册
- 申请 `MANAGE_EXTERNAL_STORAGE` 权限（需说明用途）
- 仅访问用户授权的视频文件

### 3.4 难点四：应用商店审核

**问题：** 清理类 App 可能被判定为"清理大师"类应用，审核严格

**解决方案：**
- 强调"创作者工具"定位，非系统清理
- 明确说明权限用途
- 提供详细的隐私政策
- 准备审核视频演示

---

## 4. 数据模型

### 4.1 核心数据表

```sql
-- 媒体文件表
CREATE TABLE media_files (
  id INTEGER PRIMARY KEY,
  file_path TEXT NOT NULL,
  file_name TEXT,
  file_size INTEGER,
  duration INTEGER, -- 视频时长（秒）
  created_at INTEGER, -- 创建时间戳
  is_published INTEGER DEFAULT 0, -- 是否已发布
  published_at INTEGER, -- 发布时间戳
  platform TEXT, -- 发布平台
  is_cleaned INTEGER DEFAULT 0, -- 是否已清理
  cleaned_at INTEGER, -- 清理时间戳
  recycle_bin_at INTEGER -- 回收入站时间
);

-- 清理记录表
CREATE TABLE clean_records (
  id INTEGER PRIMARY KEY,
  clean_time INTEGER NOT NULL,
  file_count INTEGER,
  total_size INTEGER,
  mode TEXT, -- 清理模式
  files_json TEXT -- 文件列表 JSON
);

-- 配置表
CREATE TABLE configs (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
```

### 4.2 数据实体

```dart
class MediaFile {
  String id;
  String filePath;
  String fileName;
  int fileSize;
  int duration;
  DateTime createdAt;
  bool isPublished;
  DateTime? publishedAt;
  String? platform;
  bool isCleaned;
  DateTime? cleanedAt;
  DateTime? recycleBinAt;
}

class CleanRecord {
  String id;
  DateTime cleanTime;
  int fileCount;
  int totalSize;
  String mode;
  List<String> files;
}

enum CleanMode {
  manual,      // 手动模式
  semiAuto,    // 半自动模式
  fullAuto     // 全自动模式
}
```

---

## 5. 项目结构

```
video-cleaner-app/
├── android/                 # Android 原生代码
├── ios/                     # iOS 原生代码
├── lib/
│   ├── main.dart           # 入口文件
│   ├── app.dart            # App 配置
│   ├── config/             # 配置相关
│   │   ├── routes.dart     # 路由配置
│   │   └── theme.dart      # 主题配置
│   ├── models/             # 数据模型
│   │   ├── media_file.dart
│   │   ├── clean_record.dart
│   │   └── config.dart
│   ├── providers/          # 状态管理
│   │   ├── media_provider.dart
│   │   ├── clean_provider.dart
│   │   └── config_provider.dart
│   ├── services/           # 业务服务
│   │   ├── media_service.dart
│   │   ├── clean_service.dart
│   │   ├── wechat_channel_service.dart
│   │   └── notification_service.dart
│   ├── utils/              # 工具类
│   │   ├── file_utils.dart
│   │   ├── permission_utils.dart
│   │   └── format_utils.dart
│   └── views/              # 页面
│       ├── home/           # 首页
│       ├── clean/          # 清理页
│       ├── settings/       # 设置页
│       └── records/        # 记录页
├── test/                   # 测试文件
├── assets/                 # 资源文件
│   ├── images/
│   └── icons/
├── pubspec.yaml            # 依赖配置
└── README.md               # 项目说明
```

---

## 6. 开发里程碑

### Phase 1：原型验证（2 周）
- [ ] 搭建 Flutter 开发环境
- [ ] 实现相册访问和视频列表展示
- [ ] 实现基础清理功能（移动到回收站）
- [ ] 实现配置页面
- [ ] 输出可运行 Demo

### Phase 2：核心功能（4 周）
- [ ] 完善清理引擎（回收站、恢复、永久删除）
- [ ] 实现清理记录功能
- [ ] 实现通知服务
- [ ] Android 无障碍服务（发布监听）
- [ ] 内部测试版发布

### Phase 3：优化与上架（6 周）
- [ ] UI/UX 优化
- [ ] 性能优化
- [ ] 隐私政策和完善说明
- [ ] 准备上架材料
- [ ] 提交 App Store 和各大应用商店

### Phase 4：变现与迭代（8 周+）
- [ ] 接入广告 SDK
- [ ] 云备份功能
- [ ] 多平台支持
- [ ] 会员体系

---

## 7. 第三方依赖

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 状态管理
  provider: ^6.0.0
  # 或 riverpod: ^2.0.0
  
  # 相册访问
  photo_manager: ^3.0.0
  image_picker: ^1.0.0
  
  # 文件操作
  path_provider: ^2.1.0
  file: ^7.0.0
  
  # 本地存储
  hive: ^2.2.0
  hive_flutter: ^1.1.0
  sqflite: ^2.3.0
  
  # 通知
  flutter_local_notifications: ^16.0.0
  
  # 权限
  permission_handler: ^11.0.0
  
  # UI 组件
  flutter_slidable: ^3.0.0  # 滑动删除
  fl_chart: ^0.65.0         # 图表（存储分析）
  
  # 工具
  intl: ^0.18.0             # 日期格式化
  share_plus: ^7.0.0        # 分享功能
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

---

## 8. 风险清单

| 风险项 | 风险等级 | 应对措施 | 负责人 |
|--------|----------|----------|--------|
| 视频号 API 限制 | 高 | 手动标记备选方案 | 开发团队 |
| iOS 后台限制 | 中 | 调整功能预期，仅支持手动/半自动 | 产品经理 |
| 应用商店审核 | 中 | 提前准备材料，合规设计 | 产品经理 |
| 用户误删投诉 | 高 | 回收站 7 天保护 + 多次确认 | 开发团队 |
| 性能问题（大文件） | 低 | 分批次处理，进度提示 | 开发团队 |

---

*文档版本：v1.0*
*创建时间：2026-03-16*
*技术负责人：待确认*
