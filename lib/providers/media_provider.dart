import 'package:flutter/foundation.dart';

import '../models/media_file.dart';
import '../services/media_service.dart';

/// 媒体 Provider
class MediaProvider extends ChangeNotifier {
  List<MediaFile> _videos = [];
  List<MediaFile> _recycleBinFiles = [];
  bool _isLoading = false;
  bool _hasPermission = false;
  String? _error;

  List<MediaFile> get videos => _videos;
  List<MediaFile> get recycleBinFiles => _recycleBinFiles;
  bool get isLoading => _isLoading;
  bool get hasPermission => _hasPermission;
  String? get error => _error;

  /// 获取可清理空间大小
  int get cleanableSpace {
    return _videos.where((v) => v.isPublished).fold(0, (sum, v) => sum + v.fileSize);
  }

  /// 获取可清理空间大小（格式化）
  String get cleanableSpaceFormatted {
    final size = cleanableSpace;
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(1)} KB';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// 获取视频总数
  int get videoCount => _videos.length;

  /// 获取已发布视频数
  int get publishedCount => _videos.where((v) => v.isPublished).length;

  /// 请求权限并加载视频
  Future<void> loadVideos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 检查权限
      _hasPermission = await MediaService.hasPermission();
      
      if (!_hasPermission) {
        _hasPermission = await MediaService.requestPermission();
      }

      if (!_hasPermission) {
        _error = '需要相册权限才能访问视频';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 加载视频
      _videos = await MediaService.getAllVideos();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = '加载视频失败：$e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 加载回收站文件
  Future<void> loadRecycleBinFiles() async {
    try {
      _recycleBinFiles = await MediaService.getRecycleBinFiles();
      notifyListeners();
    } catch (e) {
      debugPrint('加载回收站失败：$e');
    }
  }

  /// 标记视频为已发布
  void markAsPublished(String videoId) {
    final index = _videos.indexWhere((v) => v.id == videoId);
    if (index != -1) {
      _videos[index] = _videos[index].copyWith(
        isPublished: true,
        publishedAt: DateTime.now(),
        platform: '视频号',
      );
      notifyListeners();
    }
  }

  /// 批量标记已发布
  void markMultipleAsPublished(List<String> videoIds) {
    for (final videoId in videoIds) {
      markAsPublished(videoId);
    }
  }

  /// 取消标记已发布
  void markAsUnpublished(String videoId) {
    final index = _videos.indexWhere((v) => v.id == videoId);
    if (index != -1) {
      _videos[index] = _videos[index].copyWith(
        isPublished: false,
        publishedAt: null,
        platform: null,
      );
      notifyListeners();
    }
  }

  /// 获取已发布视频列表
  List<MediaFile> getPublishedVideos() {
    return _videos.where((v) => v.isPublished).toList();
  }

  /// 获取未发布视频列表
  List<MediaFile> getUnpublishedVideos() {
    return _videos.where((v) => !v.isPublished).toList();
  }

  /// 刷新权限状态
  Future<void> refreshPermission() async {
    _hasPermission = await MediaService.hasPermission();
    notifyListeners();
  }

  /// 清空错误
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// 清空列表
  void clear() {
    _videos = [];
    _recycleBinFiles = [];
    _error = null;
    notifyListeners();
  }
}
