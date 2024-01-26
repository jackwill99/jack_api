import 'dart:async';

import 'package:example/test_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:jack_api/jack_api.dart';

class ApiService {
  late JackRestApi api;

  late Dio testDio;

  Future<void> init(String url) async {
    api = JackRestApi(baseUrl: url);

    testDio = Dio();
    testDio.options = BaseOptions(baseUrl: url);
    // await api.init();
  }

  Future<dynamic> apiGetProducts(DataCacheService cacheService,
      StreamController<bool> statusController) async {
    dynamic result;

    await api.query(
      method: "GET",
      path: "/products",
      //   cacheOptions: JackApiCacheOptions(
      //     schemaName: "products",
      //     duration: const Duration(minutes: 10),
      //   ),
      //   cacheStatusStream: statusController,
      isAlreadyToken: false,
      onSuccess: (d) async {
        debugPrint("----------------------onSuccess $d----------------------");
        if (d != null) {
          result = d as dynamic;
          await cacheService.store(
            options: DataCacheOptions(
                data: d.toString(),
                expiry: const Duration(seconds: 10),
                key: "cacheService2",
                schemaName: "cacheService2"),
          );
        }
      },
    );

    return result;
  }

  Future<int?> getProducts() async {
    final data = await testDio.get("/products");
    debugPrint("-------------api service---------$data----------------------");

    return data.statusCode;
  }
}

class TestApi {
  late JackRestApi rest;

  TestApi(String baseUrl) {
    rest = JackRestApi(baseUrl: baseUrl);
  }

  Future<Response?> getProduct() async {
    Response? res;
    try {
      // res = await dio.get("/products");
      res = await rest.query(
        method: "GET",
        path: "/products",
        isAlreadyToken: false,
        onSuccess: (d) async {},
      );
    } catch (e) {
      print("----------------------error----------------------");
      rethrow;
    }
    print("---- return");
    return res;
  }

  Future<int?> getTest() async {
    int? res;
    try {
      final result = await rest.dio.get("/test");
      if (result.statusCode == 200) {
        res = 200;
        print("----------------------I returned 200----------------------");
      }
    } on DioException {
      rethrow;
    }
    return res;
  }

  Future<int> normalFunc() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
    } on Exception catch (e, s) {
      throw TestException(reason: 'lee pae ya mal', stackTrace: s);
    }
    return 20;
  }
}
