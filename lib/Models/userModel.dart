class UserModel {
  int userId;
  String name;
  String surname;
  String region;
  double internetTrafficSize;
  double minutesToOtherOperators;
  double minutesWithinTheOperator;
  double moneyAmount;
  int smsCount;
  String tariffName;
  bool activationState;
  String lastRenewDate;
  int tariffId;
  UserModel(
      {this.userId,
      this.name,
      this.surname,
      this.region,
      this.tariffName,
      this.activationState,
      this.internetTrafficSize,
      this.lastRenewDate,
      this.minutesToOtherOperators,
      this.minutesWithinTheOperator,
      this.moneyAmount,
      this.smsCount,
      this.tariffId});
  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
        userId: jsonData["UserId"],
        name: jsonData["Name"],
        surname: jsonData["Surname"],
        region: jsonData["Region"],
        tariffName: jsonData["TariffName"],
        activationState: jsonData["ActivationState"],
        internetTrafficSize: jsonData["InternetTrafficSize"],
        lastRenewDate: jsonData["LastRenewDate"],
        minutesToOtherOperators: jsonData["MinutesToOterOperators"],
        minutesWithinTheOperator: jsonData["MinutesWithinTheOperator"],
        smsCount: jsonData["SmsCount"],
        moneyAmount: jsonData["MoneyAmount"],
        tariffId: jsonData["TariffId"]);
  }
}

class UserCreationModel {
  int phoneNumber;
  String name;
  String surname;
  int regionId;
  int tariffId;

  UserCreationModel(
      {this.phoneNumber,
      this.name,
      this.surname,
      this.regionId,
      this.tariffId});

  Map<String, dynamic> toJson() {
    return {
      "phoneNumber": phoneNumber,
      "name": name,
      "surname": surname,
      "tariffId": tariffId,
      "regionId": regionId,
    };
  }
}
