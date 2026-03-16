import 'package:hive/hive.dart';

import '../models/app_config.dart';
import '../models/clean_mode.dart';

/// 配置服务
class ConfigService {
  static const String _boxName = 'app_config';
  static Box? _box;

  /// 初始化
  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  /// 获取配置
  static Future<AppConfig> getConfig() async {
    if (_box == null) await init();

    return AppConfig(
      cleanMode: CleanMode.values.firstWhere(
        (e) => e.name == _box?.get('clean_mode', defaultValue: CleanMode.manual.name),
        orElse: () => CleanMode.manual,
      ),
      recycleBinDays: _box?.get('recycle_bin_days', defaultValue: 7) ?? 7,
      backupBeforeClean: _box?.get('backup_before_clean', defaultValue: false) ?? false,
      backupPath: _box?.get('backup_path'),
      albumWhitelist: List<String>.from(
        _box?.get('album_whitelist', defaultValue: []) ?? [],
      ),
      minVideoDuration: _box?.get('min_video_duration', defaultValue: 0) ?? 0,
      enableNotification: _box?.get('enable_notification', defaultValue: true) ?? true,
    );
  }

  /// 保存配置
  static Future<void> saveConfig(AppConfig config) async {
    if (_box == null) await init();

    await _box?.put('clean_mode', config.cleanMode.name);
    await _box?.put('recycle_bin_days', config.recycleBinDays);
    await _box?.put('backup_before_clean', config.backupBeforeClean);
    await _box?.put('backup_path', config.backupPath);
    await _box?.put('album_whitelist', config.albumWhitelist);
    await _box?.put('min_video_duration', config.minVideoDuration);
    await _box?.put('enable_notification', config.enableNotification);
  }

  /// 更新清理模式
  static Future<void> updateCleanMode(CleanMode mode) async {
    if (_box == null) await init();
    await _box?.put('clean_mode', mode.name);
  }

  /// 更新回收站保留天数
  static Future<void> updateRecycleBinDays(int days) async {
    if (_box == null) await init();
    await _box?.put('recycle_bin_days', days);
  }

  /// 获取所有配置键值
  static Map<String, dynamic> getAll() {
    return _box?.toMap() ?? {};
  }

  /// 清空配置
  static Future<void> clear() async {
    if (_box == null) await init();
    await _box?.clear();
  }

  /// 关闭
  static Future<void> close() async {
    await _box?.close();
  }
}
