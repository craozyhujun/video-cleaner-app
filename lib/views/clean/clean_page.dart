import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/media_provider.dart';
import '../../providers/clean_provider.dart';
import '../../providers/config_provider.dart';
import '../../models/media_file.dart';

/// 清理页面
class CleanPage extends StatefulWidget {
  const CleanPage({super.key});

  @override
  State<CleanPage> createState() => _CleanPageState();
}

class _CleanPageState extends State<CleanPage> {
  final Set<String> _selectedVideoIds = {};
  bool _selectAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('清理素材'),
        actions: [
          if (_selectedVideoIds.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedVideoIds.clear();
                  _selectAll = false;
                });
              },
              child: Text(
                '取消选择',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
      body: Consumer3<MediaProvider, CleanProvider, ConfigProvider>(
        builder: (context, mediaProvider, cleanProvider, configProvider, child) {
          if (mediaProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (mediaProvider.error != null) {
            return _buildErrorView(context, mediaProvider);
          }

          final publishedVideos = mediaProvider.getPublishedVideos();

          if (publishedVideos.isEmpty) {
            return _buildEmptyView(context);
          }

          return _buildCleanList(context, publishedVideos, configProvider.config.cleanMode);
        },
      ),
      floatingActionButton: Consumer<CleanProvider>(
        builder: (context, cleanProvider, child) {
          if (cleanProvider.isCleaning) {
            return FloatingActionButton(
              onPressed: null,
              child: const CircularProgressIndicator(),
            );
          }

          return FloatingActionButton.extended(
            onPressed: _selectedVideoIds.isEmpty ? null : _startClean,
            icon: const Icon(Icons.cleaning_services),
            label: Text('清理 (${_selectedVideoIds.length})'),
          );
        },
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, MediaProvider mediaProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              mediaProvider.error!,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                mediaProvider.loadVideos();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              '暂无已发布视频',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '请先标记已发布的视频',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.home),
              label: const Text('返回首页'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanList(
    BuildContext context,
    List<MediaFile> videos,
    dynamic cleanMode,
  ) {
    return Column(
      children: [
        // 提示信息
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.infoContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.onInfoContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '已选择 ${_selectedVideoIds.length} 个视频，清理后将移动到回收站，7 天内可恢复',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onInfoContainer,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 视频列表
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              final isSelected = _selectedVideoIds.contains(video.id);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _selectedVideoIds.add(video.id);
                      } else {
                        _selectedVideoIds.remove(video.id);
                        _selectAll = false;
                      }
                    });
                  },
                  title: Text(
                    video.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${video.fileSizeFormatted} · ${video.durationFormatted}',
                  ),
                  secondary: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.video_file,
                      size: 32,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          ),
        ),

        // 全选按钮
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Checkbox(
                value: _selectAll,
                onChanged: (value) {
                  setState(() {
                    _selectAll = value ?? false;
                    if (_selectAll) {
                      _selectedVideoIds.addAll(videos.map((v) => v.id));
                    } else {
                      _selectedVideoIds.clear();
                    }
                  });
                },
              ),
              Text(
                '全选',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              Text(
                '共 ${videos.length} 个视频',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _startClean() {
    if (_selectedVideoIds.isEmpty) return;

    final mediaProvider = context.read<MediaProvider>();
    final cleanProvider = context.read<CleanProvider>();
    final configProvider = context.read<ConfigProvider>();

    final videosToClean = mediaProvider.videos
        .where((v) => _selectedVideoIds.contains(v.id))
        .toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('确认清理'),
        content: Text(
          '确定要清理 ${videosToClean.length} 个视频吗？\n\n清理后将移动到回收站，${configProvider.config.recycleBinDays} 天内可恢复。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await cleanProvider.clean(
                files: videosToClean,
                config: configProvider.config,
              );
              
              // 清理完成后重置选择
              setState(() {
                _selectedVideoIds.clear();
                _selectAll = false;
              });
              
              // 刷新视频列表
              mediaProvider.loadVideos();
              
              // 显示完成提示
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('清理完成'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('确认清理'),
          ),
        ],
      ),
    );
  }
}
