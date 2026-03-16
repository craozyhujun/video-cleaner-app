import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../models/media_file.dart';

const _uuid = Uuid();

class MediaService {
  static Future<bool> requestPermission() async {
    final status = await PhotoManager.requestPermissionExtend();
    return status.isAuth;
  }

  static Future<bool> hasPermission() async {
    final status = await PhotoManager.requestPermissionExtend();
    return status.isAuth;
  }

  static Future<List<MediaFile>> getAllVideos({int page = 0, int size = 50}) async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) return [];

      final albums = await PhotoManager.getAssetPathList(type: RequestType.video);
      final List<MediaFile> videos = [];

      for (final album in albums) {
        final assets = await album.getAssetListPaged(page: page, size: size);
        for (final asset in assets) {
          String filePath = '';
          try {
            final file = await asset.originFile;
            filePath = file?.path ?? '';
          } catch (e) {
            continue;
          }

          videos.add(MediaFile(
            id: _uuid.v4(),
            filePath: filePath,
            fileName: asset.title,
            fileSize: asset.width * asset.height,
            duration: asset.duration ~/ 1000,
            createdAt: asset.createDateTime,
          ));
        }
      }

      videos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return videos;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> fileExists(String filePath) async => File(filePath).exists();

  static Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> moveToRecycleBin(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return false;

      final appDir = await getApplicationDocumentsDirectory();
      final recycleBinDir = Directory('${appDir.path}/recycle_bin');
      if (!await recycleBinDir.exists()) {
        await recycleBinDir.create(recursive: true);
      }

      final fileName = filePath.split('/').last;
      await file.rename('${recycleBinDir.path}/$fileName');
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<int> clearRecycleBin() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final recycleBinDir = Directory('${appDir.path}/recycle_bin');
      if (!await recycleBinDir.exists()) return 0;

      int count = 0;
      await for (final entity in recycleBinDir.list()) {
        if (entity is File) {
          await entity.delete();
          count++;
        }
      }
      return count;
    } catch (e) {
      return 0;
    }
  }

  static Future<List<MediaFile>> getRecycleBinFiles() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final recycleBinDir = Directory('${appDir.path}/recycle_bin');
      if (!await recycleBinDir.exists()) return [];

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
      return [];
    }
  }
}
