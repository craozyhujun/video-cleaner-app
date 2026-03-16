import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/media_provider.dart';
import '../../config/routes.dart';

/// 快捷操作卡片
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '快捷操作',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    Icons.cleaning_services,
                    '一键清理',
                    Theme.of(context).colorScheme.primary,
                    () {
                      Navigator.pushNamed(context, Routes.clean);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    Icons.restore,
                    '回收站',
                    Theme.of(context).colorScheme.secondary,
                    () {
                      // TODO: 打开回收站
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('回收站功能开发中...')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    Icons.tag,
                    '标记发布',
                    Theme.of(context).colorScheme.tertiary,
                    () {
                      _showMarkDialog(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMarkDialog(BuildContext context) {
    final mediaProvider = context.read<MediaProvider>();
    final unpublishedVideos = mediaProvider.getUnpublishedVideos();

    if (unpublishedVideos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有可标记的视频')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('标记已发布视频'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: unpublishedVideos.length,
            itemBuilder: (context, index) {
              final video = unpublishedVideos[index];
              return CheckboxListTile(
                title: Text(video.fileName),
                subtitle: Text('${video.fileSizeFormatted} · ${video.durationFormatted}'),
                value: false,
                onChanged: (value) {
                  if (value == true) {
                    mediaProvider.markAsPublished(video.id);
                  }
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }
}
