class NotificationSettingsModel {
  List<String> notificationSendBlocked;
  List<String> notificationReceivedBlocked;
  bool notificationVenue;
  bool notificationSummons;


  NotificationSettingsModel({
    this.notificationSendBlocked,
    this.notificationReceivedBlocked,
    this.notificationVenue,

    this.notificationSummons
  });
}