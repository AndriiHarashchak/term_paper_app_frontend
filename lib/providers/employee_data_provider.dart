import 'dart:convert';

import 'package:term_paper_app_frontend/Models/EmployeeModel.dart';
import 'package:term_paper_app_frontend/providers/ApiDataReceiver.dart';

class EmployeeDataProvider {
  ApiProvider provider;
  EmployeeDataProvider() {
    provider = ApiProvider();
  }

  Future<Employee> login(int login, String password) async {
    Map<String, String> params = {"id": login.toString(), "password": password};
    try {
      var response = await provider.getDataFromAPI(
          endpoint: "api/employee/login", query: params);
      return Employee.fromJson(response as Map);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Employee> getEmployee(int employeeId) async {
    Map<String, String> params = {"employeeId": employeeId.toString()};
    try {
      var response = await provider.getDataFromAPI(
          endpoint: "api/employee", query: params);
      return Employee.fromJson(response as Map);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Employee> createEmployee(EmployeeCreateModel newEmployee) async {
    try {
      var requestBody = json.encode(newEmployee.toJson());
      var response = await provider.postRequest(
          endpoint: "api/employee", body: requestBody);
      return Employee.fromJson(response);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Employee> editEmployee(EmployeeCreateModel employeeToEdit) async {
    try {
      var requestBody = json.encode(employeeToEdit.toJsonEdit());
      var response = await provider.putResponseToAPI(
          endpoint: "api/employee", query: null, body: requestBody);
      return Employee.fromJson(response);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
