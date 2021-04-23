class RegionModel {
  int regionId;
  String regionName;
  bool isActive;
  RegionModel({this.regionId, this.regionName, this.isActive});

  factory RegionModel.fromJson(Map<String, dynamic> jsonData) {
    return RegionModel(
        regionId: jsonData["RegionId"],
        regionName: jsonData["RegionName"],
        isActive: jsonData["IsActive"]);
  }
  Map<String, dynamic> toJson() {
    return {"regionId": regionId, "regionName": regionName};
  }
}
