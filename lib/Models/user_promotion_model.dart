/*{
    "PromotionId": 2118399,
    "Conditions": "X0544NF0796IK0JIB4",
    "Description": "Nisi obcaecati tenetur accusantium. Omnis non et voluptatem et? Voluptas a.",
    "ActivationDate": "2021-04-13T21:42:09.23",
    "EndDate": "2021-07-09T21:42:09.23"
  }  */

class UserPromotionModel {
  int promotionId;
  String conditions;
  String description;
  String activationDate;
  String endDate;

  UserPromotionModel({
    this.promotionId,
    this.conditions,
    this.description,
    this.activationDate,
    this.endDate,
  });

  factory UserPromotionModel.fromJson(Map<String, dynamic> jsonData) {
    return UserPromotionModel(
      promotionId: jsonData["PromotionId"],
      conditions: jsonData["Conditions"],
      description: jsonData["Description"],
      activationDate: jsonData["ActivationDate"],
      endDate: jsonData["EndDate"],
    );
  }
}
