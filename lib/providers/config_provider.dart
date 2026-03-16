import 'package:flutter/foundation.dart';

import '../models/app_config.dart';
import '../models/clean_mode.dart';
import '../services/config_service.dart';

/// 配置 Provider
class ConfigProvider extends ChangeNotifier {
  AppConfig _config = AppConfig();
  bool _isLoading = true;
  String? _error;

  AppConfig get config => _config;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// 初始化配置
  Future<void> loadConfig() async {
    _isLoading = true;
    notifyListeners();

    try {
      _config = await ConfigService.getConfig();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = '加载配置失败：$e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 更新清理模式
  Future<void> updateCleanMode(CleanMode mode) async {
    try {
      _config = _config.copyWith(cleanMode: mode);
      await ConfigService.updateCleanMode(mode);
      notifyListeners();
    } catch (e) {
      _error = '更新配置失败：$e';
      notifyListeners();
    }
  }

  /// 更新回收站保留天数
  Future<void> updateRecycleBinDays(int days) async {
    try {
      _config = _config.copyWith(recycleBinDays: days);
      await ConfigService.updateRecycleBinDays(days);
      notifyListeners();
    } catch (e) {
      _error = '更新配置失败：$e';
      notifyListeners();
    }
  }

  /// 更新备份设置
  Future<void> updateBackupSetting({
    bool? backupBeforeClean,
    String? backupPath,
  }) async {
    try {
      _config = _config.copyWith(
        backupBeforeClean: backupBeforeClean ?? _config.backupBeforeClean,
        backupPath: backupPath ?? _config.backupPath,
      );
      await ConfigService.saveConfig(_config);
      notifyListeners();
    } catch (e) {
      _error = '更新配置失败：$e';
      notifyListeners();
    }
  }

  /// 更新通知设置
  Future<void> updateNotificationSetting(bool enable) async {
    try {
      _config = _config.copyWith(enableNotification: enable);
      await ConfigService.saveConfig(_config);
      notifyListeners();
    } catch (e) {
      _error = '更新配置失败：$e';
      notifyListeners();
    }
  }

  /// 更新白名单相册
  Future<void> updateAlbumWhitelist(List<String> albums) async {
    try {
      _config = _config.copyWith(albumWhitelist: albums);
      await ConfigService.saveConfig(_config);
      notifyListeners();
    } catch (e) {
      _error = '更新配置失败：$e';
      notifyListeners();
    }
  }

  /// 更新最小视频时长
  Future<void> updateMinVideoDuration(int seconds) async {
    try {
      _config = _config.copyWith(minVideoDuration: seconds);
      await ConfigService.saveConfig(_config);
      notifyListeners();
    } catch (e) {
      _error = '更新配置失败：$e';
      notifyListeners();
    }
  }

  /// 重置配置为默认
  Future<void> resetConfig() async {
    try {
      _config = AppConfig();
      await ConfigService.saveConfig(_config);
      notifyListeners();
    } catch (e) {
      _error = '重置配置失败：$e';
      notifyListeners();
    }
  }

  /// 清空错误
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
