class PaymentModel {
  int paymentId;
  int userId;
  double rate;
  String paymentDateAndTime;
  String description;

  PaymentModel({
    this.paymentId,
    this.userId,
    this.rate,
    this.paymentDateAndTime,
    this.description,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> jsonData) {
    return PaymentModel(
        paymentId: jsonData["PaymentId"],
        userId: jsonData["UserRef"],
        rate: jsonData["Rate"],
        paymentDateAndTime: jsonData["PaymentDateAndTime"],
        description: jsonData["Description"]);
  }
}
