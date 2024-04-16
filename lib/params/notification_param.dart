import 'package:app_core/params/notification_data_param.dart';
import 'package:app_core/utilities/notification/app_notification_channel.dart';

class NotificationParam {
  final Future<void> Function(String token)? onRetrieveNotificationToken;
  final AppNotificationChannel? notificationChannel;
  final void Function(NotificationDataParam)? onReceiveNotification;
  final void Function(NotificationDataParam)? onOpenNotification;

  NotificationParam({
    this.onRetrieveNotificationToken,
    this.notificationChannel,
    this.onReceiveNotification,
    this.onOpenNotification,
  });
}
