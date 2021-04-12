import 'dart:convert';

import 'package:term_paper_app_frontend/Models/UserTariffModel.dart';

class TariffModel {
  int tariffId;
  String tariffName;
  double minutesWithinTheOperator;
  double minutesToOtherOperators;
  double internetTrafficSize;
  double smsCount;
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
      minutesToOtherOperators: jsonData["MinutesToOtherOperators"],
      minutesWithinTheOperator: jsonData["MinutesWithinTheOperator"],
      internetTrafficSize: jsonData["InternetTrafficSize"],
      smsCount: jsonData["SmsCount"],
      callPrice: jsonData["CallPrice"],
      registrationDate: jsonData["RegistrationDate"],
      regionRef: jsonData["RegionRef"],
      pricePerPeriod: jsonData["PricePerPeriond"],
      isActive: jsonData["IsActive"],
      userTariffInfo: UserTariffModel.fromJson(jsonData["UserTariffs"][0]),
    );
  }
}
