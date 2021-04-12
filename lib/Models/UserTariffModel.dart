/* "RecordId": 6,
    "UserId": 123456789,
    "TariffId": 25,
    "TariffName": "Lucio1976",
    "IsServicePackageActivated": false,
    "IsActive": false,
    "LastRenewDate": null,
    "ActivationDate": "2012-01-01T00:00:00",
    "DeactivationDate": "2020-09-08T00:00:00" */

class UserTariffModel {
  int userId;
  int tariffId;
  String tariffName;
  bool isServicePackageActivated;
  bool isActive;
  String lastRenewDate;
  String activationDate;
  String deactivationDate;

  UserTariffModel(
      {this.userId,
      this.tariffId,
      this.tariffName,
      this.isServicePackageActivated,
      this.isActive,
      this.lastRenewDate,
      this.activationDate,
      this.deactivationDate});
  factory UserTariffModel.fromJson(Map<String, dynamic> jsonData) {
    return UserTariffModel(
        userId: jsonData["UserId"],
        tariffId: jsonData["TariffId"],
        tariffName: jsonData["TariffName"],
        isServicePackageActivated: jsonData["IsServicePackageActivated"],
        isActive: jsonData["isActive"],
        lastRenewDate: jsonData["LastRenewDate"],
        activationDate: jsonData["ActivationDate"],
        deactivationDate: jsonData["deactivationDate"]);
  }
}
