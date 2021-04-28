import 'dart:convert';

import 'package:term_paper_app_frontend/Models/office_model.dart';
import 'package:term_paper_app_frontend/Models/post_model.dart';
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

  Future<bool> deactivateOffice(int officeId) async {
    Map<String, String> params = {
      "officeId": officeId.toString(),
      //"serviceId": serviceId.toString()
    };
    try {
      await _provider.deleteResponceToAPI(
          endpoint: "api/employee/offices", query: params);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deactivatePromotion(int promotionId) async {
    Map<String, String> params = {
      "promotionId": promotionId.toString(),
    };
    try {
      await _provider.deleteResponceToAPI(
          endpoint: "api/basedata/promotions", query: params);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deactivateService(int serviceId) async {
    Map<String, String> params = {
      "serviceId": serviceId.toString(),
    };
    try {
      await _provider.deleteResponceToAPI(
          endpoint: "api/basedata/services", query: params);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<PromotionModel> registerPromotion(PromotionModel promotion) async {
    try {
      var requestBody = json.encode(promotion.toJson());
      var response = await _provider.postRequest(
          endpoint: "api/basedata/promotions", body: requestBody);
      return PromotionModel.fromJson(response);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<ServiceModel> registerService(ServiceModel service) async {
    try {
      var requestBody = json.encode(service.toJson());
      var response = await _provider.postRequest(
          endpoint: "api/basedata/services", body: requestBody);
      return ServiceModel.fromJson(response);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<ServiceModel> updateService(ServiceModel updatedService) async {
    try {
      var requestBody = json.encode(updatedService.toJson());
      var response = await _provider.putResponseToAPI(
          endpoint: "api/basedata/services", query: null, body: requestBody);
      return ServiceModel.fromJson(response);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<PromotionModel> updatePromotion(
      PromotionModel updatedPromotion) async {
    try {
      var requestBody = json.encode(updatedPromotion.toJson());
      var response = await _provider.putResponseToAPI(
          endpoint: "api/basedata/promotions", query: null, body: requestBody);
      return PromotionModel.fromJson(response);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<TariffModel> createTariff(TariffModel newTariff) async {
    try {
      var requestBody = json.encode(newTariff.toJson());
      var response = await _provider.postRequest(
          endpoint: "api/basedata/tariffs", body: requestBody);
      return TariffModel.fromJson(response);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<bool> deactivateTariff(int tariffId) async {
    Map<String, String> params = {
      "tariffId": tariffId.toString(),
    };
    try {
      await _provider.deleteResponceToAPI(
          endpoint: "api/basedata/tariffs", query: params);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deactivateRegion(int regionId) async {
    Map<String, String> params = {
      "regionId": regionId.toString(),
    };
    try {
      await _provider.deleteResponceToAPI(
          endpoint: "api/basedata/regions", query: params);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<RegionModel>> getRegionsHistory() async {
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/basedata/regions/history", query: null);
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

  Future<RegionModel> registerRegion(RegionModel region) async {
    Map<String, String> params = {
      "regionName": region.regionName,
    };
    try {
      var response = await _provider.postRequest(
          endpoint: "api/basedata/regions", query: params, body: null);
      return RegionModel.fromJson(response);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<RegionModel> updateRegion(RegionModel updatedRegion) async {
    try {
      var requestBody = json.encode(updatedRegion.toJson());
      var response = await _provider.putResponseToAPI(
          endpoint: "api/basedata/regions", query: null, body: requestBody);
      return RegionModel.fromJson(response);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<List<PostModel>> getPosts() async {
    try {
      var response = await _provider.getDataFromAPI(
          endpoint: "api/employee/posts", query: null);
      List<PostModel> data = [];
      (response as List).forEach((element) {
        data.add(PostModel.fromJson(element));
      });
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
