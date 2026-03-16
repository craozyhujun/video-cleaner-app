import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/media_file.dart';
import '../models/clean_record.dart';
import '../models/app_config.dart';
import 'media_service.dart';
import 'notification_service.dart';

const _uuid = Uuid();

/// 清理结果
class CleanResult {
  final int successCount;
  final int failedCount;
  final int totalSize;
  final List<String> successFiles;
  final List<String> failedFiles;

  CleanResult({
    required this.successCount,
    required this.failedCount,
    required this.totalSize,
    required this.successFiles,
    required this.failedFiles,
  });

  String get totalSizeFormatted {
    if (totalSize < 1024) {
      return '$totalSize B';
    } else if (totalSize < 1024 * 1024) {
      return '${(totalSize / 1024).toStringAsFixed(1)} KB';
    } else if (totalSize < 1024 * 1024 * 1024) {
      return '${(totalSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(totalSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }
}

/// 清理引擎服务
class CleanService {
  /// 执行清理
  static Future<CleanResult> clean({
    required List<MediaFile> files,
    required AppConfig config,
    Function(int current, int total)? onProgress,
  }) async {
    int successCount = 0;
    int failedCount = 0;
    int totalSize = 0;
    final List<String> successFiles = [];
    final List<String> failedFiles = [];

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      
      try {
        // 检查文件是否存在
        final exists = await MediaService.fileExists(file.filePath);
        if (!exists) {
          failedCount++;
          failedFiles.add('${file.fileName} (文件不存在)');
          continue;
        }

        // 根据配置执行清理
        bool success = false;
        if (config.recycleBinDays > 0) {
          // 移动到回收站
          success = await MediaService.moveToRecycleBin(file.filePath);
        } else {
          // 直接删除
          success = await MediaService.deleteFile(file.filePath);
        }

        if (success) {
          successCount++;
          totalSize += file.fileSize;
          successFiles.add(file.fileName);
        } else {
          failedCount++;
          failedFiles.add(file.fileName);
        }
      } catch (e) {
        debugPrint('清理文件失败 ${file.fileName}: $e');
        failedCount++;
        failedFiles.add('${file.fileName} ($e)');
      }

      // 进度回调
      onProgress?.call(i + 1, files.length);
    }

    // 显示完成通知
    if (config.enableNotification && successCount > 0) {
      await NotificationService.showCleanCompleteNotification(
        fileCount: successCount,
        freedSpace: CleanResult(
          successCount: successCount,
          failedCount: failedCount,
          totalSize: totalSize,
          successFiles: [],
          failedFiles: [],
        ).totalSizeFormatted,
      );
    }

    return CleanResult(
      successCount: successCount,
      failedCount: failedCount,
      totalSize: totalSize,
      successFiles: successFiles,
      failedFiles: failedFiles,
    );
  }

  /// 创建清理记录
  static CleanRecord createCleanRecord(CleanResult result, String mode) {
    return CleanRecord(
      id: _uuid.v4(),
      cleanTime: DateTime.now(),
      fileCount: result.successCount,
      totalSize: result.totalSize,
      mode: mode,
      files: result.successFiles,
    );
  }

  /// 恢复文件
  static Future<bool> restoreFile(MediaFile file) async {
    try {
      if (file.recycleBinAt == null) {
        debugPrint('文件不在回收站中');
        return false;
      }

      return await MediaService.restoreFromRecycleBin(
        file.filePath,
        file.filePath, // TODO: 需要记录原始路径
      );
    } catch (e) {
      debugPrint('恢复文件失败：$e');
      return false;
    }
  }

  /// 永久删除
  static Future<bool> permanentDelete(MediaFile file) async {
    try {
      return await MediaService.deleteFile(file.filePath);
    } catch (e) {
      debugPrint('永久删除失败：$e');
      return false;
    }
  }

  /// 清空回收站
  static Future<int> clearRecycleBin() async {
    return await MediaService.clearRecycleBin();
  }
}
