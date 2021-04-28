class PostModel {
  int postId;
  String postName;
  String description;
  double basicSalary;

  PostModel({this.postId, this.postName, this.description, this.basicSalary});

  factory PostModel.fromJson(Map<String, dynamic> jsonData) {
    return new PostModel(
      postId: jsonData["PostId"],
      postName: jsonData["PostName"],
      description: jsonData["Description"],
      basicSalary: jsonData["BasicSalary"].toDouble(),
    );
  }
}
