import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum AppNotificationChannelImportance {
  unspecified,
  none,
  min,
  low,
  defaultImportance,
  high,
  max;

  Importance getValue() {
    switch (this) {
      case AppNotificationChannelImportance.unspecified:
        return Importance.unspecified;
      case AppNotificationChannelImportance.none:
        return Importance.none;
      case AppNotificationChannelImportance.min:
        return Importance.min;
      case AppNotificationChannelImportance.low:
        return Importance.low;
      case AppNotificationChannelImportance.defaultImportance:
        return Importance.defaultImportance;
      case AppNotificationChannelImportance.high:
        return Importance.high;
      case AppNotificationChannelImportance.max:
        return Importance.max;
      default:
        return Importance.defaultImportance;
    }
  }
}
