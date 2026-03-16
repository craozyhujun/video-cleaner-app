/// 清理记录模型
class CleanRecord {
  final String id;
  final DateTime cleanTime;
  final int fileCount;
  final int totalSize;
  final String mode;
  final List<String> files;

  CleanRecord({
    required this.id,
    required this.cleanTime,
    required this.fileCount,
    required this.totalSize,
    required this.mode,
    required this.files,
  });

  /// 获取总大小（格式化）
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

  /// 从 Map 创建
  factory CleanRecord.fromMap(Map<String, dynamic> map) {
    return CleanRecord(
      id: map['id'] as String,
      cleanTime: DateTime.fromMillisecondsSinceEpoch(map['clean_time'] as int),
      fileCount: map['file_count'] as int,
      totalSize: map['total_size'] as int,
      mode: map['mode'] as String,
      files: (map['files_json'] as String)
          .split(',')
          .where((f) => f.isNotEmpty)
          .toList(),
    );
  }

  /// 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clean_time': cleanTime.millisecondsSinceEpoch,
      'file_count': fileCount,
      'total_size': totalSize,
      'mode': mode,
      'files_json': files.join(','),
    };
  }

  @override
  String toString() {
    return 'CleanRecord(id: $id, time: $cleanTime, files: $fileCount, size: $totalSizeFormatted)';
  }
}
