import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/media_provider.dart';
import '../../providers/config_provider.dart';
import '../../config/routes.dart';
import 'widgets/storage_card.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_videos.dart';

/// 首页
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MediaProvider>().loadVideos();
      context.read<ConfigProvider>().loadConfig();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // 首页
        break;
      case 1:
        Navigator.pushNamed(context, Routes.clean);
        break;
      case 2:
        Navigator.pushNamed(context, Routes.records);
        break;
      case 3:
        Navigator.pushNamed(context, Routes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('视频素材清理助手'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<MediaProvider>().loadVideos();
            },
            tooltip: '刷新',
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildHomeContent() : const Center(child: Text('开发中...')),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: '清理',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '记录',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: () async {
        await context.read<MediaProvider>().loadVideos();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 存储卡片
            const StorageCard(),
            
            const SizedBox(height: 24),
            
            // 快捷操作
            const QuickActions(),
            
            const SizedBox(height: 24),
            
            // 最近视频
            const RecentVideos(),
          ],
        ),
      ),
    );
  }
}
