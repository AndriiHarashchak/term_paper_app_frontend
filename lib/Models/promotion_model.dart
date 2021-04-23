/* "PromotionId": 823889,
    "PromotionName": "PromotionName823889",
    "Conditions": "7I7Z2Y4FOT1233R960M0X9XGE7KWKYSUW6D3BNFSQS08TF",
    "Description": "Facere odio. Quia aut. Earum dolor iusto maiores dicta.",
    "ActivePeriod": 122 */
class PromotionModel {
  int promotionId;
  String promotionName;
  String conditions;
  String description;
  int activePeriod;
  String registrationDate;

  PromotionModel(
      {this.promotionId,
      this.promotionName,
      this.conditions,
      this.description,
      this.activePeriod,
      this.registrationDate});

  factory PromotionModel.fromJson(Map<String, dynamic> jsonData) {
    return PromotionModel(
        promotionId: jsonData["PromotionId"],
        promotionName: jsonData["PromotionName"],
        conditions: jsonData["Conditions"],
        description: jsonData["Description"] ?? "",
        activePeriod: jsonData["ActivePeriod"] ?? -1,
        registrationDate: jsonData["RegistationTime"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "promotionId": promotionId,
      "promotionName": promotionName,
      "conditions": conditions,
      "description": description,
      "activePeriod": activePeriod
    };
  }
}
