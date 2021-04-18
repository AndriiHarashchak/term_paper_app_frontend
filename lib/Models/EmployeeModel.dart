class Employee {
  int id;
  String name;
  String surname;
  double salary;
  int postRef;
  int officeRef;
  String dismissalDate;
  String hiringDate;
  String officeAdress;
  String postName;
  String password;
  Employee({
    this.id,
    this.name,
    this.surname,
    this.salary,
    this.postRef,
    this.dismissalDate,
    this.hiringDate,
    this.officeRef,
    this.officeAdress,
    this.postName,
    this.password,
  });
  factory Employee.fromJson(Map<String, dynamic> jsonData) {
    return Employee(
        id: jsonData["EmployeeId"],
        name: jsonData["Name"],
        surname: jsonData["Surname"],
        salary: jsonData["Salary"],
        postRef: jsonData["PostRef"],
        officeRef: jsonData["OfficeRef"],
        hiringDate: jsonData["HiringDate"],
        officeAdress: jsonData["OfficeAdress"],
        postName: jsonData["PostName"],
        password: jsonData["AuthInfo"] != null
            ? jsonData["AuthInfo"]["Password"]
            : "");
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["Name"] = name;
    data["Surname"] = surname;
    data["Salary"] = salary;
    data["PostRef"] = postRef;
    data["OfficeRef"] = officeRef;
    data["EmployeeId"] = id;
    data["Salary"] = salary;
    data["PostName"] = postName;
    data["HiringDate"] = hiringDate;
    data["OfficeAdress"] = officeAdress;
    return data;
  }
}
