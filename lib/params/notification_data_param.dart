class NotificationDataParam {
  final String? messageId;
  final String? notificationId;
  final Map<String, dynamic> payloadData;

  NotificationDataParam({
    this.messageId,
    this.notificationId,
    required this.payloadData,
  });
}
