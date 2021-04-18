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
      minutesToOtherOperators: jsonData["MinutesToOtherOperators"] != null
          ? jsonData["MinutesToOtherOperators"].toDouble()
          : -1,
      minutesWithinTheOperator: jsonData["MinutesWithinTheOperator"] != null
          ? jsonData["MinutesWithinTheOperator"].toDouble()
          : -1,
      internetTrafficSize: jsonData["InternetTrafficSize"].toDouble() ?? 0,
      smsCount: jsonData["SmsCount"] ?? -1,
      callPrice: jsonData["CallPrice"].toDouble() ?? 0,
      registrationDate: jsonData["RegistrationDate"],
      regionRef: jsonData["RegionRef"] ?? 0,
      pricePerPeriod: jsonData["PricePerPeriod"].toDouble() ?? 0,
      isActive: jsonData["IsActive"],
      smsPrice: jsonData["SmsPrice"].toDouble(),
      userTariffInfo: jsonData["UserTariffs"].length > 0
          ? UserTariffModel.fromJson(jsonData["UserTariffs"][0])
          : null,
    );
  }
}
