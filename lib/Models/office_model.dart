class OfficeModel {
  int officeId;
  String adress;
  String openedAt;
  String closingDate;
  bool isWorking;
  OfficeModel(
      {this.officeId,
      this.adress,
      this.openedAt,
      this.closingDate,
      this.isWorking});

  factory OfficeModel.fromJson(Map<String, dynamic> jsonData) {
    return OfficeModel(
      officeId: jsonData["OfficeId"],
      adress: jsonData["Adress"],
      openedAt: jsonData["OpenedAt"],
      isWorking: jsonData["IsWorking"],
      closingDate: jsonData["ClosingDate"],
    );
  }
}
