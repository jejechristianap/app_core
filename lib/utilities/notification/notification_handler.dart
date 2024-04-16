import 'dart:convert';
import 'dart:io';

import 'package:app_core/params/notification_data_param.dart';
import 'package:app_core/utilities/notification/app_notification_channel.dart';
import 'package:firebase_collection/firebase_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  NotificationHandler._internal();

  bool _isConfigured = false;
  final String messageIdKey = 'messageId';

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late final AndroidNotificationChannel _notificationChannel;

  static NotificationHandler shared = NotificationHandler._internal();

  /// These functions are intended for tracking purposes
  void Function(NotificationDataParam)? onReceiveNotification;
  void Function(NotificationDataParam)? onOpenNotification;

  Future<void> configure({
    Future<void> Function(String token)? onRetrieveNotificationToken,
    AppNotificationChannel? appNotificationChannel,
  }) async {
    if (_isConfigured) return;

    _notificationChannel = appNotificationChannel ??
        const AndroidNotificationChannel(
          'app_notification_channel_id',
          'App Notification',
          importance: Importance.max,
        );
    await _configureLocalNotification();

    FirebaseMessaging.instance.onTokenRefresh.listen((_) {
      _registerToken(
        onRetrieveNotificationToken: onRetrieveNotificationToken,
      );
    });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onOpenNotification?.call(
        NotificationDataParam(
          payloadData: message.data,
          messageId: message.messageId,
        ),
      );
      handleMessage(message.data);
    });

    FirebaseMessaging.onMessage.listen((message) {
      onReceiveNotification?.call(
        NotificationDataParam(
          payloadData: message.data,
          messageId: message.messageId,
        ),
      );
      RemoteNotification? notification = message.notification;
      if (Platform.isAndroid) {
        AndroidNotification? android = notification?.android;

        if (notification != null && android != null) {
          Map<String, dynamic> payload = message.data;
          payload[messageIdKey] = message.messageId;

          _notificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _notificationChannel.id,
                _notificationChannel.name,
                styleInformation: const BigTextStyleInformation(''),
              ),
            ),
            payload: jsonEncode(payload),
          );
        }
      } else if (Platform.isIOS) {
        AppleNotification? apple = notification?.apple;
        if (notification != null && apple != null) {
          Map<String, dynamic> payload = message.data;
          payload[messageIdKey] = message.messageId;

          _notificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              iOS: DarwinNotificationDetails(
                interruptionLevel: InterruptionLevel.active,
                presentSound: true,
              ),
            ),
            payload: jsonEncode(payload),
          );
        }
      }
    });

    _isConfigured = true;
  }

  Future<void> _configureLocalNotification() async {
    if (Platform.isAndroid) {
      _notificationsPlugin.initialize(
        InitializationSettings(
          android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification,
          ),
        ),
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          try {
            Map<String, dynamic> data = jsonDecode(response.payload ?? '');
            handleMessage(data);
            onOpenNotification?.call(
              NotificationDataParam(
                payloadData: data,
                messageId: data[messageIdKey],
              ),
            );
          } catch (_) {}
        },
      );
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_notificationChannel);
    }
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    // TODO execute local notification
  }

  void handleMessage(Map<String, dynamic> data) {
    String? url = data['url'];

    if (url != null) {
      // DeeplinkHandler.handleUri(Uri.parse(url));
    }
  }

  Future<void> _registerToken({
    Future<void> Function(String token)? onRetrieveNotificationToken,
  }) async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.getNotificationSettings();

    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    try {
      String? token = await FirebaseMessaging.instance.getToken();

      debugPrint('Notification Token = $token');

      if (token != null) {
        onRetrieveNotificationToken?.call(token);
      }
    } catch (error) {
      debugPrint('Notification Error: ${error.toString()}');
    }
  }

  Future<void> handleStartAppFromNotification() async {
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await _notificationsPlugin.getNotificationAppLaunchDetails();

    NotificationResponse? response =
        notificationAppLaunchDetails?.notificationResponse;

    String? payload = response?.payload;

    if (initialMessage != null) {
      handleMessage(initialMessage.data);

      onOpenNotification?.call(
        NotificationDataParam(
          payloadData: initialMessage.data,
          messageId: initialMessage.messageId,
        ),
      );
    } else if (payload != null) {
      try {
        Map<String, dynamic> jsonData = jsonDecode(payload);
        handleMessage(jsonData);

        onOpenNotification?.call(
          NotificationDataParam(
            payloadData: jsonData,
            messageId: jsonData[messageIdKey],
          ),
        );
      } catch (_) {
        // Do Nothing while we're just preventing any crashses happen in the run time
      }
    }
  }

  Future<void> handlePermission({
    Future<void> Function(String token)? onRetrieveNotificationToken,
  }) async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings =
    await FirebaseMessaging.instance.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _registerToken(
        onRetrieveNotificationToken: onRetrieveNotificationToken,
      );
    }
  }
}
