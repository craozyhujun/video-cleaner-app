import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/media_file.dart';

const _uuid = Uuid();

/// 媒体文件服务
class MediaService {
  /// 请求相册权限
  static Future<bool> requestPermission() async {
    final status = await PhotoManager.requestPermissionExtend();
    return status.isAuth;
  }

  /// 检查相册权限
  static Future<bool> hasPermission() async {
    final status = await PhotoManager.getPermissionStatus();
    return status.isAuth;
  }

  /// 获取所有视频
  static Future<List<MediaFile>> getAllVideos({
    int page = 0,
    int size = 50,
  }) async {
    try {
      // 请求权限
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        debugPrint('没有相册权限');
        return [];
      }

      // 获取所有相册
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
      );

      final List<MediaFile> videos = [];

      // 遍历所有相册获取视频
      for (final album in albums) {
        final assets = await album.getAssetListPaged(
          page: page,
          size: size,
        );

        for (final asset in assets) {
          // 跳过已删除或隐藏的视频
          if (asset.isDeleted || asset.hidden) {
            continue;
          }

          // 获取文件路径（需要完整权限）
          String filePath = '';
          try {
            final file = await asset.originFile;
            filePath = file?.path ?? '';
          } catch (e) {
            debugPrint('获取文件路径失败：$e');
            continue;
          }

          // 创建媒体文件对象
          final video = MediaFile(
            id: _uuid.v4(),
            filePath: filePath,
            fileName: asset.name,
            fileSize: asset.size,
            duration: asset.duration.inSeconds,
            createdAt: asset.createDateTime,
          );

          videos.add(video);
        }
      }

      // 按创建时间倒序排序
      videos.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return videos;
    } catch (e) {
      debugPrint('获取视频列表失败：$e');
      return [];
    }
  }

  /// 根据路径获取视频
  static Future<MediaFile?> getVideoByPath(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return null;
      }

      final stat = await file.stat();

      return MediaFile(
        id: _uuid.v4(),
        filePath: filePath,
        fileName: file.path.split('/').last,
        fileSize: stat.size,
        duration: 0, // 需要额外获取
        createdAt: stat.modified,
      );
    } catch (e) {
      debugPrint('获取视频失败：$e');
      return null;
    }
  }

  /// 检查文件是否存在
  static Future<bool> fileExists(String filePath) async {
    return File(filePath).exists();
  }

  /// 获取文件大小
  static Future<int> getFileSize(String filePath) async {
    final stat = await File(filePath).stat();
    return stat.size;
  }

  /// 删除文件
  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('删除文件失败：$e');
      return false;
    }
  }

  /// 移动文件到回收站
  static Future<bool> moveToRecycleBin(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return false;
      }

      // 获取回收站目录
      final appDir = await getApplicationDocumentsDirectory();
      final recycleBinDir = Directory('${appDir.path}/recycle_bin');
      
      if (!await recycleBinDir.exists()) {
        await recycleBinDir.create(recursive: true);
      }

      // 生成新路径
      final fileName = filePath.split('/').last;
      final newPath = '${recycleBinDir.path}/$fileName';

      // 移动文件
      await file.rename(newPath);
      return true;
    } catch (e) {
      debugPrint('移动到回收站失败：$e');
      return false;
    }
  }

  /// 从回收站恢复文件
  static Future<bool> restoreFromRecycleBin(
    String recycleBinPath,
    String originalPath,
  ) async {
    try {
      final file = File(recycleBinPath);
      if (!await file.exists()) {
        return false;
      }

      // 确保原目录存在
      final originalDir = Directory(originalPath.split('/').skipLast(1).join('/'));
      if (!await originalDir.exists()) {
        await originalDir.create(recursive: true);
      }

      // 移动回原位置
      await file.rename(originalPath);
      return true;
    } catch (e) {
      debugPrint('恢复文件失败：$e');
      return false;
    }
  }

  /// 清空回收站
  static Future<int> clearRecycleBin() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final recycleBinDir = Directory('${appDir.path}/recycle_bin');
      
      if (!await recycleBinDir.exists()) {
        return 0;
      }

      int count = 0;
      await for (final entity in recycleBinDir.list()) {
        if (entity is File) {
          await entity.delete();
          count++;
        }
      }

      return count;
    } catch (e) {
      debugPrint('清空回收站失败：$e');
      return 0;
    }
  }

  /// 获取回收站文件列表
  static Future<List<MediaFile>> getRecycleBinFiles() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final recycleBinDir = Directory('${appDir.path}/recycle_bin');
      
      if (!await recycleBinDir.exists()) {
        return [];
      }

      final List<MediaFile> files = [];
      await for (final entity in recycleBinDir.list()) {
        if (entity is File) {
          final stat = await entity.stat();
          files.add(MediaFile(
            id: _uuid.v4(),
            filePath: entity.path,
            fileName: entity.path.split('/').last,
            fileSize: stat.size,
            duration: 0,
            createdAt: stat.modified,
            recycleBinAt: stat.modified,
          ));
        }
      }

      return files;
    } catch (e) {
      debugPrint('获取回收站文件失败：$e');
      return [];
    }
  }
}
