/// 清理模式枚举
enum CleanMode {
  manual,      // 手动模式
  semiAuto,    // 半自动模式
  fullAuto,    // 全自动模式
}

extension CleanModeExtension on CleanMode {
  String get displayName {
    switch (this) {
      case CleanMode.manual:
        return '手动模式';
      case CleanMode.semiAuto:
        return '半自动模式';
      case CleanMode.fullAuto:
        return '全自动模式';
    }
  }

  String get description {
    switch (this) {
      case CleanMode.manual:
        return '用户主动触发清理，每次需确认';
      case CleanMode.semiAuto:
        return '检测发布成功后推送通知，用户确认清理';
      case CleanMode.fullAuto:
        return '后台监听发布成功，自动清理（无需干预）';
    }
  }
}
