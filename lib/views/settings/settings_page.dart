import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/config_provider.dart';
import '../../models/clean_mode.dart';

/// 设置页面
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: Consumer<ConfigProvider>(
        builder: (context, configProvider, child) {
          if (configProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              // 清理设置
              _buildSectionHeader(context, '清理设置'),
              
              _buildListTile(
                context,
                icon: Icons.cleaning_services,
                title: '清理模式',
                subtitle: configProvider.config.cleanMode.displayName,
                trailing: Text(
                  configProvider.config.cleanMode.description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () => _showCleanModeDialog(context, configProvider),
              ),

              _buildListTile(
                context,
                icon: Icons.restore,
                title: '回收站保留天数',
                subtitle: configProvider.config.recycleBinDaysDescription,
                onTap: () => _showRecycleBinDaysDialog(context, configProvider),
              ),

              _buildSwitchListTile(
                context,
                icon: Icons.backup,
                title: '清理前备份',
                subtitle: '清理前自动备份到指定位置',
                value: configProvider.config.backupBeforeClean,
                onChanged: (value) {
                  configProvider.updateBackupSetting(backupBeforeClean: value);
                },
              ),

              if (configProvider.config.backupBeforeClean)
                _buildListTile(
                  context,
                  icon: Icons.folder,
                  title: '备份路径',
                  subtitle: configProvider.config.backupPath ?? '未设置',
                  onTap: () {
                    // TODO: 选择备份路径
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('备份路径选择功能开发中...')),
                    );
                  },
                ),

              const Divider(height: 24),

              // 通知设置
              _buildSectionHeader(context, '通知设置'),

              _buildSwitchListTile(
                context,
                icon: Icons.notifications,
                title: '清理通知',
                subtitle: '清理完成后显示通知',
                value: configProvider.config.enableNotification,
                onChanged: (value) {
                  configProvider.updateNotificationSetting(value);
                },
              ),

              const Divider(height: 24),

              // 高级设置
              _buildSectionHeader(context, '高级设置'),

              _buildListTile(
                context,
                icon: Icons.filter_list,
                title: '最小视频时长',
                subtitle: configProvider.config.minVideoDuration > 0
                    ? '忽略短于 ${configProvider.config.minVideoDuration} 秒的视频'
                    : '无限制',
                onTap: () => _showMinDurationDialog(context, configProvider),
              ),

              _buildListTile(
                context,
                icon: Icons.folder_special,
                title: '白名单相册',
                subtitle: '${configProvider.config.albumWhitelist.length} 个相册',
                onTap: () {
                  // TODO: 选择白名单相册
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('白名单相册功能开发中...')),
                  );
                },
              ),

              const Divider(height: 24),

              // 关于
              _buildSectionHeader(context, '关于'),

              _buildListTile(
                context,
                icon: Icons.info_outline,
                title: '版本',
                subtitle: 'v1.0.0',
              ),

              _buildListTile(
                context,
                icon: Icons.description,
                title: '用户协议',
                onTap: () {
                  // TODO: 显示用户协议
                },
              ),

              _buildListTile(
                context,
                icon: Icons.privacy_tip,
                title: '隐私政策',
                onTap: () {
                  // TODO: 显示隐私政策
                },
              ),

              _buildListTile(
                context,
                icon: Icons.help_outline,
                title: '帮助与反馈',
                onTap: () {
                  // TODO: 显示帮助
                },
              ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : trailing,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }

  Widget _buildSwitchListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      onChanged: onChanged,
    );
  }

  void _showCleanModeDialog(BuildContext context, ConfigProvider configProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择清理模式'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: CleanMode.values.map((mode) {
            return RadioListTile<CleanMode>(
              title: Text(mode.displayName),
              subtitle: Text(mode.description),
              value: mode,
              groupValue: configProvider.config.cleanMode,
              onChanged: (value) {
                configProvider.updateCleanMode(value!);
                Navigator.pop(context);
              },
            );
          }).toList(),
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

  void _showRecycleBinDaysDialog(BuildContext context, ConfigProvider configProvider) {
    final days = [1, 3, 7, 15, 30, 0];
    final dayLabels = ['1 天', '3 天', '7 天', '15 天', '30 天', '永久保留'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('回收站保留天数'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(days.length, (index) {
            return RadioListTile<int>(
              title: Text(dayLabels[index]),
              value: days[index],
              groupValue: configProvider.config.recycleBinDays,
              onChanged: (value) {
                configProvider.updateRecycleBinDays(value!);
                Navigator.pop(context);
              },
            );
          }),
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

  void _showMinDurationDialog(BuildContext context, ConfigProvider configProvider) {
    final durations = [0, 10, 30, 60, 120, 300];
    final durationLabels = ['无限制', '10 秒', '30 秒', '1 分钟', '2 分钟', '5 分钟'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('最小视频时长'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(durations.length, (index) {
            return RadioListTile<int>(
              title: Text(durationLabels[index]),
              value: durations[index],
              groupValue: configProvider.config.minVideoDuration,
              onChanged: (value) {
                configProvider.updateMinVideoDuration(value!);
                Navigator.pop(context);
              },
            );
          }),
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
