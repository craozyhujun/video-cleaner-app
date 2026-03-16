import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 通知服务
class NotificationService {
  static FlutterLocalNotificationsPlugin? _notifications;

  /// 初始化通知
  static Future<void> init(FlutterLocalNotificationsPlugin notifications) async {
    _notifications = notifications;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications?.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// 通知点击回调
  static void _onNotificationTapped(NotificationResponse response) {
    // TODO: 跳转到对应页面
    print('Notification tapped: ${response.payload}');
  }

  /// 显示普通通知
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'video_cleaner_channel',
      '视频清理通知',
      channelDescription: '视频素材清理助手的 notificaiton 通道',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications?.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// 显示清理完成通知
  static Future<void> showCleanCompleteNotification({
    required int fileCount,
    required String freedSpace,
  }) async {
    await showNotification(
      id: 1001,
      title: '清理完成',
      body: '已清理 $fileCount 个文件，释放 $freedSpace 空间',
      payload: 'clean_complete',
    );
  }

  /// 显示发布成功检测通知（半自动模式）
  static Future<void> showPublishDetectedNotification({
    required String videoName,
  }) async {
    await showNotification(
      id: 1002,
      title: '检测到新发布视频',
      body: '"$videoName" 已发布到视频号，是否清理原始素材？',
      payload: 'publish_detected',
    );
  }

  /// 取消所有通知
  static Future<void> cancelAll() async {
    await _notifications?.cancelAll();
  }

  /// 取消指定通知
  static Future<void> cancel(int id) async {
    await _notifications?.cancel(id);
  }
}
