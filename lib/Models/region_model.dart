class RegionModel {
  int regionId;
  String regionName;
  RegionModel({this.regionId, this.regionName});

  factory RegionModel.fromJson(Map<String, dynamic> jsonData) {
    return RegionModel(
        regionId: jsonData["RegionId"], regionName: jsonData["RegionName"]);
  }
}
