import 'package:term_paper_app_frontend/Models/office_model.dart';
import 'package:term_paper_app_frontend/Models/promotion_model.dart';
import 'package:term_paper_app_frontend/Models/region_model.dart';
import 'package:term_paper_app_frontend/Models/service_model.dart';
import 'package:term_paper_app_frontend/Models/tariff_model.dart';
import 'package:term_paper_app_frontend/providers/ApiDataReceiver.dart';

class GeneralDataProvider {
  ApiProvider _provider;
  GeneralDataProvider() : _provider = ApiProvider();

  Future<List<RegionModel>> getRegions() async {
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/basedata/regions", query: null);
      if (response == null) return null;
      List<RegionModel> regions = [];
      (response as List).forEach((element) {
        regions.add(RegionModel.fromJson(element));
      });
      return regions;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<TariffModel>> getTariffs({int regionId}) async {
    Map<String, String> params;
    if (regionId != null) {
      params = {"regionId": regionId.toString()};
    }
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/basedata/tariffs", query: params);
      if (response != null) {
        List<TariffModel> tariffs = [];
        (response as List).forEach((element) {
          tariffs.add(TariffModel.fromJson(element));
        });
        return tariffs;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }

    return null;
  }

  Future<List<ServiceModel>> getServices() async {
    //Map<String, String> params = {"tariffId": tariffId.toString()};
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/basedata/services", query: null);
      if (response == null) return null;
      List<ServiceModel> services = [];
      (response as List).forEach((element) {
        services.add(ServiceModel.fromJson(element));
      });
      return services;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<ServiceModel>> getServicesHistory() async {
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/basedata/services/history", query: null);
      if (response == null) return null;
      List<ServiceModel> services = [];
      (response as List).forEach((element) {
        services.add(ServiceModel.fromJson(element));
      });
      return services;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<PromotionModel>> getPromotions() async {
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/basedata/promotions", query: null);
      if (response == null) return null;
      List<PromotionModel> promotions = [];
      (response as List).forEach((element) {
        promotions.add(PromotionModel.fromJson(element));
      });
      return promotions;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<PromotionModel>> getPromotionsHistory() async {
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/basedata/promotions/history", query: null);
      if (response == null) return null;
      List<PromotionModel> promotions = [];
      (response as List).forEach((element) {
        promotions.add(PromotionModel.fromJson(element));
      });
      return promotions;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<TariffModel>> getTariffsHistory() async {
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/basedata/tariffs/history", query: null);
      if (response == null) return null;
      List<TariffModel> tariffs = [];
      (response as List).forEach((element) {
        tariffs.add(TariffModel.fromJson(element));
      });
      return tariffs;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<OfficeModel>> getOffices() async {
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/employee/offices", query: null);
      if (response == null) return null;
      List<OfficeModel> offices = [];
      (response as List).forEach((element) {
        offices.add(OfficeModel.fromJson(element));
      });
      return offices;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}