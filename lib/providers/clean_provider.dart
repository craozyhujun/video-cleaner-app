import 'package:flutter/foundation.dart';
import '../models/media_file.dart';
import '../models/clean_record.dart';
import '../models/app_config.dart';
import '../services/clean_service.dart';

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
  int get progressPercent => _totalProgress == 0 ? 0 : ((_currentProgress / _totalProgress) * 100).toInt();

  Future<void> clean({required List<MediaFile> files, required AppConfig config}) async {
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
      final record = CleanService.createCleanRecord(result, config.cleanMode.name);
      _cleanRecords.insert(0, record);
      _isCleaning = false;
      notifyListeners();
    } catch (e) {
      _error = '清理失败：$e';
      _isCleaning = false;
      notifyListeners();
    }
  }

  Future<void> permanentDelete(MediaFile file) async {
    try {
      await CleanService.permanentDelete(file);
      notifyListeners();
    } catch (e) {
      _error = '删除失败：$e';
      notifyListeners();
    }
  }

  Future<void> clearRecycleBin() async {
    try {
      await CleanService.clearRecycleBin();
      notifyListeners();
    } catch (e) {
      _error = '清空回收站失败：$e';
      notifyListeners();
    }
  }

  Future<void> loadCleanRecords() async {
    _cleanRecords = [];
    notifyListeners();
  }

  void clearError() { _error = null; notifyListeners(); }
  void resetProgress() { _isCleaning = false; _currentProgress = 0; _totalProgress = 0; notifyListeners(); }
}
