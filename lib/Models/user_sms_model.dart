/* {
    "UserFromOperatorPhoneNumber": 2122748862,
    "ReceiverPhoneNumber": 475534591,
    "SmsType": 5,
    "SmsTypeName": "Terry2007",
    "Price": 0.79,
    "TimeSent": "2020-07-15T10:09:53.07"
  }, */

class SmsModel {
  int userFromOperatorPhoneNumber;
  int receiverPhoneNumber;
  int smsType;
  String smsTypeName;
  double price;
  String timeSent;

  SmsModel({
    this.userFromOperatorPhoneNumber,
    this.receiverPhoneNumber,
    this.smsType,
    this.smsTypeName,
    this.price,
    this.timeSent,
  });
  factory SmsModel.fromJson(Map<String, dynamic> jsonData) {
    return SmsModel(
        userFromOperatorPhoneNumber: jsonData["UserFromOperatorPhoneNumber"],
        receiverPhoneNumber: jsonData["ReceiverPhoneNumber"],
        smsType: jsonData["SmsType"],
        smsTypeName: jsonData["SmsTypeName"],
        price: jsonData["Price"].toDouble(),
        timeSent: jsonData["TimeSent"]);
  }
}
