class NotificationSettingsModel {
  List<String>? blocked;
  bool? venueInvite;
  bool? summons;
  bool? all;
  bool? comingToBeacon;

  NotificationSettingsModel(
      {this.blocked,
      this.venueInvite,
      this.summons,
      this.comingToBeacon,
      this.all});
}
