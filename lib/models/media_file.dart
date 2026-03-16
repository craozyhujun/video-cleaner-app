/// 媒体文件模型
class MediaFile {
  final String id;
  final String filePath;
  final String fileName;
  final int fileSize;
  final int duration; // 视频时长（秒）
  final DateTime createdAt;
  final bool isPublished;
  final DateTime? publishedAt;
  final String? platform;
  final bool isCleaned;
  final DateTime? cleanedAt;
  final DateTime? recycleBinAt;

  MediaFile({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.duration,
    required this.createdAt,
    this.isPublished = false,
    this.publishedAt,
    this.platform,
    this.isCleaned = false,
    this.cleanedAt,
    this.recycleBinAt,
  });

  /// 获取文件大小（格式化）
  String get fileSizeFormatted {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  /// 获取视频时长（格式化）
  String get durationFormatted {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// 从 Map 创建（数据库读取）
  factory MediaFile.fromMap(Map<String, dynamic> map) {
    return MediaFile(
      id: map['id'] as String,
      filePath: map['file_path'] as String,
      fileName: map['file_name'] as String,
      fileSize: map['file_size'] as int,
      duration: map['duration'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      isPublished: map['is_published'] == 1,
      publishedAt: map['published_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['published_at'] as int)
          : null,
      platform: map['platform'] as String?,
      isCleaned: map['is_cleaned'] == 1,
      cleanedAt: map['cleaned_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['cleaned_at'] as int)
          : null,
      recycleBinAt: map['recycle_bin_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['recycle_bin_at'] as int)
          : null,
    );
  }

  /// 转换为 Map（数据库存储）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'file_path': filePath,
      'file_name': fileName,
      'file_size': fileSize,
      'duration': duration,
      'created_at': createdAt.millisecondsSinceEpoch,
      'is_published': isPublished ? 1 : 0,
      'published_at': publishedAt?.millisecondsSinceEpoch,
      'platform': platform,
      'is_cleaned': isCleaned ? 1 : 0,
      'cleaned_at': cleanedAt?.millisecondsSinceEpoch,
      'recycle_bin_at': recycleBinAt?.millisecondsSinceEpoch,
    };
  }

  /// 复制并修改
  MediaFile copyWith({
    String? id,
    String? filePath,
    String? fileName,
    int? fileSize,
    int? duration,
    DateTime? createdAt,
    bool? isPublished,
    DateTime? publishedAt,
    String? platform,
    bool? isCleaned,
    DateTime? cleanedAt,
    DateTime? recycleBinAt,
  }) {
    return MediaFile(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      isPublished: isPublished ?? this.isPublished,
      publishedAt: publishedAt ?? this.publishedAt,
      platform: platform ?? this.platform,
      isCleaned: isCleaned ?? this.isCleaned,
      cleanedAt: cleanedAt ?? this.cleanedAt,
      recycleBinAt: recycleBinAt ?? this.recycleBinAt,
    );
  }

  @override
  String toString() {
    return 'MediaFile(id: $id, fileName: $fileName, fileSize: $fileSizeFormatted)';
  }
}
