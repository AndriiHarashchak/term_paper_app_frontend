/* {
    "UserFromOperatorPhoneNumber": 2122748862,
    "InterlocutorPhoneNumber": 938679254,
    "CallDateTime": "2020-02-14T19:24:34.72",
    "Duration": 3616,
    "CallPrice": 327.34,
    "CallTime": 271,
    "CallType": 0,
    "CallTypeName": "Norris377"
  }, */

class CallModel {
  int userFromOperatorPhoneNumber;
  int interlocutorPhoneNumber;
  String callDateTime;
  int duration;
  double callPrice;
  int callType;
  String callTypeName;

  CallModel({
    this.userFromOperatorPhoneNumber,
    this.interlocutorPhoneNumber,
    this.callDateTime,
    this.callPrice,
    this.callType,
    this.callTypeName,
    this.duration,
  });

  factory CallModel.fromJson(Map<String, dynamic> jsonData) {
    return CallModel(
      userFromOperatorPhoneNumber: jsonData["UserFromOperatorPhoneNumber"],
      interlocutorPhoneNumber: jsonData["InterlocutorPhoneNumber"],
      callDateTime: jsonData["CallDateTime"],
      callPrice: jsonData["CallPrice"],
      duration: jsonData["Duration"],
      callType: jsonData["CallType"],
      callTypeName: jsonData["CallTypeName"],
    );
  }
}
