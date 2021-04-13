import 'package:term_paper_app_frontend/Models/UserTariffModel.dart';

class TariffModel {
  int tariffId;
  String tariffName;
  double minutesWithinTheOperator;
  double minutesToOtherOperators;
  double internetTrafficSize;
  int smsCount;
  double smsPrice;
  double callPrice;
  double pricePerPeriod;
  double registrationDate;
  int regionRef;
  bool isActive;
  String activationDate;
  UserTariffModel userTariffInfo;
  TariffModel(
      {this.tariffId,
      this.tariffName,
      this.minutesWithinTheOperator,
      this.minutesToOtherOperators,
      this.internetTrafficSize,
      this.smsCount,
      this.callPrice,
      this.pricePerPeriod,
      this.registrationDate,
      this.activationDate,
      this.regionRef,
      this.isActive,
      this.smsPrice,
      this.userTariffInfo});
  factory TariffModel.fromJson(Map<String, dynamic> jsonData) {
    return TariffModel(
      tariffId: jsonData["TariffId"],
      tariffName: jsonData["TariffName"],
      minutesToOtherOperators: jsonData["MinutesToOtherOperators"].toDouble(),
      minutesWithinTheOperator: jsonData["MinutesWithinTheOperator"].toDouble(),
      internetTrafficSize: jsonData["InternetTrafficSize"].toDouble(),
      smsCount: jsonData["SmsCount"],
      callPrice: jsonData["CallPrice"].toDouble(),
      registrationDate: jsonData["RegistrationDate"],
      regionRef: jsonData["RegionRef"],
      pricePerPeriod: jsonData["PricePerPeriod"].toDouble(),
      isActive: jsonData["IsActive"],
      smsPrice: jsonData["SmsPrice"].toDouble(),
      userTariffInfo: UserTariffModel.fromJson(jsonData["UserTariffs"][0]),
    );
  }
}
