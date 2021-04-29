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
  String registrationDate;
  int regionRef;
  bool isActive;
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
      registrationDate: jsonData["RegistationTime"],
      regionRef: jsonData["RegionRef"] ?? 0,
      pricePerPeriod: jsonData["PricePerPeriod"].toDouble() ?? 0,
      isActive: jsonData["IsActive"],
      smsPrice: jsonData["SmsPrice"].toDouble(),
      userTariffInfo: jsonData["UserTariffs"].length > 0
          ? UserTariffModel.fromJson(jsonData["UserTariffs"][0])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "tariffName": tariffName,
      "internetTrafficSize": internetTrafficSize,
      "minutesWithinTheOperator": minutesWithinTheOperator,
      "minutesToOtherOperators": minutesToOtherOperators,
      "smsCount": smsCount,
      "smsPrice": smsPrice,
      "callPrice": callPrice,
      "pricePerPeriod": pricePerPeriod,
      "regionRef": regionRef
    };
  }
}
/* {
  "tariffName": "string",
  "internetTrafficSize": 0,
  "minutesWithinTheOperator": 0,
  "minutesToOtherOperators": 0,
  "smsCount": 0,
  "smsPrice": 0,
  "callPrice": 0,
  "pricePerPeriod": 0,
  "regionRef": 0
} */