class Employee {
  String name;
  String surname;
  double salary;
  int postRef;
  int officeRef;
  String dismissalDate;
  String hiringDate;
  String officeAdress;
  String postName;
  Employee(
      {this.name,
      this.surname,
      this.salary,
      this.postRef,
      this.dismissalDate,
      this.hiringDate,
      this.officeRef,
      this.officeAdress,
      this.postName});
  factory Employee.fromJson(Map<String, dynamic> jsonData) {
    return Employee(
        name: jsonData["Name"],
        surname: jsonData["Surname"],
        salary: jsonData["Salary"],
        postRef: jsonData["PostRef"],
        officeRef: jsonData["OfficeRef"],
        hiringDate: jsonData["HiringDate"],
        officeAdress: jsonData["OfficeRefNavigation"]["Adress"],
        postName: jsonData["PostRefNavigation"]["Description"]);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["Name"] = name;
    data["Surname"] = surname;
    data["Salary"] = salary;
    data["PostRef"] = postRef;
    data["OfficeRef"] = officeRef;
    data["HiringDate"] = hiringDate;
    var map = {
      'Adress': officeAdress,
    };
    data["OfficeRefNavigation"] = map;
    map = {'Description': postName};
    data["PostRefNavigation"] = map;
    //data["PostRefNavigation"]["Description"] = postName;
    return data;
  }
}
