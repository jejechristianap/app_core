import 'package:app_core/params/notification_param.dart';
import 'package:app_core/utilities/notification/notification_handler.dart';
import 'package:deeplink/deeplink.dart';
import 'package:firebase_collection/firebase_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppInitializer {
  AppInitializer._internal();

  static AppInitializer shared = AppInitializer._internal();

  late final NotificationHandler _notificationHandler =
      NotificationHandler.shared;
  late final List<DeeplinkParam>? listDeeplink;

  Future<void> initialize({
    required Widget app,
    required String deviceId,
    NotificationParam? notificationParam,
    Future<void> Function()? onPreRun,
    Future<void> Function()? onPostRun,
    // List<DeeplinkParam>? deeplinks,
    bool isTrackerLoggerEnabled = kDebugMode,
    String? mixpanelToken,
    bool isEnableFirebaseAnalytics = true,
    void Function(FlutterErrorDetails)? onFlutterError,
  }) async {
    await _configure(
      notificationParam: notificationParam,
      isTrackerLoggerEnabled: isTrackerLoggerEnabled,
      mixpanelToken: mixpanelToken,
      isEnableFirebaseAnalytics: isEnableFirebaseAnalytics,
    );
    await onPreRun?.call();

    runApp(app);

    await onPostRun?.call();
  }

  Future<void> _configure({
    required bool isTrackerLoggerEnabled,
    NotificationParam? notificationParam,
    String? mixpanelToken,
    bool isEnableFirebaseAnalytics = true,
  }) async {
    await _notificationHandler.configure(
      onRetrieveNotificationToken:
      notificationParam?.onRetrieveNotificationToken,
      appNotificationChannel: notificationParam?.notificationChannel,
    );
    await _notificationHandler.handlePermission(
      onRetrieveNotificationToken:
      notificationParam?.onRetrieveNotificationToken,
    );

    _notificationHandler.onReceiveNotification =
        notificationParam?.onReceiveNotification;

    _notificationHandler.onOpenNotification =
        notificationParam?.onOpenNotification;
  }

  void setDeeplinks(List<DeeplinkParam>? deeplinks) {
    DeeplinkHandler.registerDeeplinks(deeplinks ?? []);
  }

  Future<void> setOnBackgroundMessage(
      Future<void> Function(RemoteMessage) onBackgroundMessage,
      ) async {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }

  void registerDeepLink() async {
    DeeplinkHandler.registerDeeplinks(listDeeplink ?? []);
    await _notificationHandler.handleStartAppFromNotification();
  }
}
