import 'package:term_paper_app_frontend/Models/UserTariffModel.dart';
import 'package:term_paper_app_frontend/Models/tariff_model.dart';
import 'package:term_paper_app_frontend/Models/userModel.dart';
import 'package:term_paper_app_frontend/Models/user_promotion_model.dart';
import 'package:term_paper_app_frontend/providers/ApiDataReceiver.dart';

class UserDataProvider {
  final ApiProvider _provider;
  UserDataProvider() : _provider = ApiProvider();

  Future<UserModel> getUserInfo(int userId) async {
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/user/$userId", query: null);
      return UserModel.fromJson(response as Map);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<TariffModel> getCurrentUserTariff(int userId) async {
    Map<String, String> params = {"userId": userId.toString()};
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/user/tariff", query: params);
      if (response != null) {
        return TariffModel.fromJson(response as Map);
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }

  Future<List<UserTariffModel>> getUsertariffsHistory(int userId) async {
    Map<String, String> params = {"userId": userId.toString()};
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/user/tariff/history", query: params);
      if (response == null) return null;
      List<UserTariffModel> tariffsHistory = [];
      (response as List).forEach((element) {
        tariffsHistory.add(UserTariffModel.fromJson(element));
      });
      return tariffsHistory;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<UserPromotionModel>> getUserPromotions(int userId) async {
    Map<String, String> params = {"userId": userId.toString()};
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/user/promotions", query: params);
      if (response == null) return null;
      List<UserPromotionModel> userPromotions = [];
      (response as List).forEach((element) {
        userPromotions.add(UserPromotionModel.fromJson(element));
      });
      return userPromotions;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<UserPromotionModel>> getUserPromotionsHistory(int userId) async {
    Map<String, String> params = {"userId": userId.toString()};
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/user/promotions/history", query: params);
      if (response == null) return null;
      List<UserPromotionModel> userPromotionsHistory = [];
      (response as List).forEach((element) {
        userPromotionsHistory.add(UserPromotionModel.fromJson(element));
      });
      return userPromotionsHistory;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
