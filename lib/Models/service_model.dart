/* "ServiceId": 338973,
    "ServiceName": "Service 338973 name",
    "Conditions": "OG",
    "Price": 1464.58,
    "ActivePeriod": 181,
    "RegistationTime": "2020-10-11T04:33:52.44" */

class ServiceModel {
  int serviceId;
  String serviceName;
  String conditions;
  double price;
  int activePeriod;
  String registrationDate;

  ServiceModel({
    this.serviceId,
    this.serviceName,
    this.conditions,
    this.price,
    this.activePeriod,
    this.registrationDate,
  });
  factory ServiceModel.fromJson(Map<String, dynamic> jsonData) {
    return ServiceModel(
      serviceId: jsonData["ServiceId"],
      serviceName: jsonData["ServiceName"],
      conditions: jsonData["Conditions"],
      price: jsonData["Price"].toDouble(),
      activePeriod: jsonData["ActivePeriod"],
      registrationDate: jsonData["RegistationTime"],
    );
  }
}
