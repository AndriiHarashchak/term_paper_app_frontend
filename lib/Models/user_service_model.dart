/* [
  {
    "ServiceId": 1338973,
    "ServiceName": "Service 1338973 name",
    "Conditions": "U5814Y10P8I3V3MMM9PXR92938P281O9D7KQ4CDX",
    "Price": 1584.86,
    "ActivationDate": "2021-04-15T11:22:29.977",
    "EndDate": "2026-02-15T11:22:29.977"
  }
] */

class UserServiceModel {
  int userServiceId;
  int serviceId;
  String serviceName;
  String conditions;
  double price;
  String activationDate;
  String endDate;

  UserServiceModel(
      {this.userServiceId,
      this.serviceId,
      this.serviceName,
      this.conditions,
      this.price,
      this.activationDate,
      this.endDate});

  factory UserServiceModel.fromJson(Map<String, dynamic> jsonData) {
    return UserServiceModel(
        userServiceId: jsonData["UserServiceId"],
        serviceId: jsonData["ServiceId"],
        serviceName: jsonData["ServiceName"],
        conditions: jsonData["Conditions"],
        price: jsonData["Price"].toDouble(),
        activationDate: jsonData["ActivationDate"],
        endDate: jsonData["EndDate"]);
  }
  /* Map<String, dynamic> toJson(UserServiceModel serviceModel){

  } */
}
