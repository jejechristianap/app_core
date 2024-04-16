import 'package:app_core/utilities/notification/app_notification_channel_importance.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotificationChannel extends AndroidNotificationChannel {
  AppNotificationChannel(
    super.id,
    super.name, {
    AppNotificationChannelImportance? importance,
  }) : super(importance: importance?.getValue() ?? Importance.max);
}