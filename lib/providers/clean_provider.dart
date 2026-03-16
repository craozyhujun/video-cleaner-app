import 'package:flutter/foundation.dart';

import '../models/media_file.dart';
import '../models/clean_record.dart';
import '../models/app_config.dart';
import '../services/clean_service.dart';

/// 清理 Provider
class CleanProvider extends ChangeNotifier {
  List<CleanRecord> _cleanRecords = [];
  bool _isCleaning = false;
  int _currentProgress = 0;
  int _totalProgress = 0;
  String? _error;

  List<CleanRecord> get cleanRecords => _cleanRecords;
  bool get isCleaning => _isCleaning;
  int get currentProgress => _currentProgress;
  int get totalProgress => _totalProgress;
  String? get error => _error;

  /// 获取清理进度百分比
  int get progressPercent {
    if (_totalProgress == 0) return 0;
    return ((_currentProgress / _totalProgress) * 100).toInt();
  }

  /// 执行清理
  Future<void> clean({
    required List<MediaFile> files,
    required AppConfig config,
  }) async {
    _isCleaning = true;
    _currentProgress = 0;
    _totalProgress = files.length;
    _error = null;
    notifyListeners();

    try {
      final result = await CleanService.clean(
        files: files,
        config: config,
        onProgress: (current, total) {
          _currentProgress = current;
          _totalProgress = total;
          notifyListeners();
        },
      );

      // 创建清理记录
      final record = CleanService.createCleanRecord(
        result,
        config.cleanMode.displayName,
      );
      _cleanRecords.insert(0, record);

      _isCleaning = false;
      notifyListeners();
    } catch (e) {
      _error = '清理失败：$e';
      _isCleaning = false;
      notifyListeners();
    }
  }

  /// 恢复文件
  Future<void> restoreFile(MediaFile file) async {
    try {
      final success = await CleanService.restoreFile(file);
      if (success) {
        _recycleBinFiles.removeWhere((f) => f.id == file.id);
        notifyListeners();
      } else {
        _error = '恢复失败';
        notifyListeners();
      }
    } catch (e) {
      _error = '恢复失败：$e';
      notifyListeners();
    }
  }

  /// 永久删除
  Future<void> permanentDelete(MediaFile file) async {
    try {
      final success = await CleanService.permanentDelete(file);
      if (success) {
        _recycleBinFiles.removeWhere((f) => f.id == file.id);
        notifyListeners();
      } else {
        _error = '删除失败';
        notifyListeners();
      }
    } catch (e) {
      _error = '删除失败：$e';
      notifyListeners();
    }
  }

  /// 清空回收站
  Future<void> clearRecycleBin() async {
    try {
      final count = await CleanService.clearRecycleBin();
      _recycleBinFiles.clear();
      notifyListeners();
    } catch (e) {
      _error = '清空回收站失败：$e';
      notifyListeners();
    }
  }

  /// 加载清理记录（从本地存储）
  Future<void> loadCleanRecords() async {
    // TODO: 从数据库加载
    _cleanRecords = [];
    notifyListeners();
  }

  /// 添加清理记录
  void addCleanRecord(CleanRecord record) {
    _cleanRecords.insert(0, record);
    notifyListeners();
  }

  /// 清空错误
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// 重置进度
  void resetProgress() {
    _isCleaning = false;
    _currentProgress = 0;
    _totalProgress = 0;
    notifyListeners();
  }
}
