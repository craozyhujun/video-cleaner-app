import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/media_provider.dart';
import '../../../models/media_file.dart';

class RecentVideos extends StatelessWidget {
  const RecentVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MediaProvider>(
      builder: (context, mediaProvider, child) {
        if (mediaProvider.isLoading) {
          return const Card(child: Padding(padding: EdgeInsets.all(40), child: Center(child: CircularProgressIndicator())));
        }
        if (mediaProvider.error != null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 16),
                  Text(mediaProvider.error!, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(onPressed: () => mediaProvider.loadVideos(), icon: const Icon(Icons.refresh), label: const Text('重试')),
                ],
              ),
            ),
          );
        }
        if (mediaProvider.videos.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.video_library_outlined, size: 48, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('暂无视频', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('请先拍摄或导入视频', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
                ],
              ),
            ),
          );
        }

        final recentVideos = mediaProvider.videos.take(5).toList();
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('最近视频', style: Theme.of(context).textTheme.titleMedium),
                  TextButton(onPressed: () {}, child: const Text('查看全部')),
                ]),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentVideos.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) => _buildVideoTile(context, recentVideos[index]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildVideoTile(BuildContext context, MediaFile video) {
    return ListTile(
      leading: Container(
        width: 60, height: 60,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
        child: Icon(Icons.video_file, size: 32, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      title: Text(video.fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('${video.fileSizeFormatted} · ${video.durationFormatted} · ${DateFormat('MM-dd HH:mm').format(video.createdAt)}', style: Theme.of(context).textTheme.bodySmall),
          if (video.isPublished) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(4)),
              child: Text('已发布到视频号', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
            ),
          ],
        ],
      ),
      trailing: video.isPublished ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 24) : null,
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('点击了：${video.fileName}'))),
    );
  }
}
