import 'clean_mode.dart';

/// 应用配置模型
class AppConfig {
  final CleanMode cleanMode;
  final int recycleBinDays;
  final bool backupBeforeClean;
  final String? backupPath;
  final List<String> albumWhitelist;
  final int minVideoDuration;
  final bool enableNotification;

  AppConfig({
    this.cleanMode = CleanMode.manual,
    this.recycleBinDays = 7,
    this.backupBeforeClean = false,
    this.backupPath,
    this.albumWhitelist = const [],
    this.minVideoDuration = 0,
    this.enableNotification = true,
  });

  /// 获取回收站保留天数描述
  String get recycleBinDaysDescription {
    if (recycleBinDays >= 30) {
      return '永久保留';
    }
    return '$recycleBinDays 天';
  }

  /// 复制并修改
  AppConfig copyWith({
    CleanMode? cleanMode,
    int? recycleBinDays,
    bool? backupBeforeClean,
    String? backupPath,
    List<String>? albumWhitelist,
    int? minVideoDuration,
    bool? enableNotification,
  }) {
    return AppConfig(
      cleanMode: cleanMode ?? this.cleanMode,
      recycleBinDays: recycleBinDays ?? this.recycleBinDays,
      backupBeforeClean: backupBeforeClean ?? this.backupBeforeClean,
      backupPath: backupPath ?? this.backupPath,
      albumWhitelist: albumWhitelist ?? this.albumWhitelist,
      minVideoDuration: minVideoDuration ?? this.minVideoDuration,
      enableNotification: enableNotification ?? this.enableNotification,
    );
  }

  @override
  String toString() {
    return 'AppConfig(mode: $cleanMode, recycleDays: $recycleBinDays)';
  }
}
