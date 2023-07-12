import "dart:async";

import "package:dio/dio.dart";
import "package:dio_http2_adapter/dio_http2_adapter.dart";
import "package:flutter/foundation.dart";
import "package:get_it/get_it.dart";
import "package:jack_api/src/cache/cache_interceptor.dart";
import "package:jack_api/src/cache/cache_options.dart";
import "package:jack_api/src/cache/cache_service.dart";
import "package:jack_api/src/cache/isar_service.dart";
import "package:jack_api/src/jack_rest_api/dio_methods.dart";
import "package:jack_api/src/jack_rest_api/model.dart";
import "package:jack_api/src/util.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";

class JackRestApi {
  /// ### Config while instantiating class
  ///
  /// [baseUrl] is the main base url
  ///
  /// [connectTimeout] is in seconds of time and default is 20 seconds.
  ///
  /// *If you defined state methods, they will be used in every query and if you don't, `false` the flag of particular state methods in each query*
  JackRestApi({
    required String baseUrl,
    int? connectTimeout,
    Future<bool> Function()? onBeforeValidate,
    CallBack? onAfterValidate,
    Future<void> Function()? onTimeOutError,
    Future<void> Function()? onError,
    bool useHttp2 = false,
  }) {
    RestApiData.isUseHttp2 = useHttp2;

    _init(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
    );

    unawaited(GetIt.I.registerSingleton(IsarService()).initialize());

    _onBeforeValidate = onBeforeValidate;

    _onAfterValidate = onAfterValidate;

    _onTimeOutError = onTimeOutError;

    _onError = onError;
  }

  String? get myToken => RestApiData.token;
  set myToken(String? value) {
    RestApiData.token = value;
    if (value != null) {
      RestApiData.dio.options.headers["Authorization"] = "Bearer $myToken";
    }
  }

  void setIsOnline({bool? value}) {
    RestApiData.isOnline = value;
  }

  CallBackWithReturn? _onBeforeValidate;

  CallBack? _onAfterValidate;

  CallBackNoArgs? _onTimeOutError;

  CallBackNoArgs? _onError;

  void _init({
    required String baseUrl,
    int? connectTimeout,
  }) {
    final connectionTimeout = connectTimeout == null
        ? const Duration(seconds: 20)
        : Duration(seconds: connectTimeout);
    RestApiData.dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectionTimeout,
      ),
    )..options.headers["Content-Type"] = "application/json";
    if (RestApiData.isUseHttp2) {
      RestApiData.dio.httpClientAdapter = Http2Adapter(
        ConnectionManager(
          idleTimeout: connectionTimeout,
          onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
        ),
      );
    }

    if (!kReleaseMode) {
      RestApiData.dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
        ),
      );
    }
    RestApiData.dio.interceptors.add(
      CacheInterceptor(),
    );
    RestApiData.methods =
        JackApiMethods(baseUrl: baseUrl, dio: RestApiData.dio);
  }

  /// [method] is the method of API request
  ///
  /// [path] is the api endPoint
  ///
  /// [onSuccess] is the callBack function when you receive successfully the data from server
  ///
  /// [basePath] is to modify the API base path of your project
  ///
  /// [contentType] is also to modify the content type of your API request
  ///
  /// [token] is optional token of your authenticated api request. If you don't want to set every time called this method, you can pr-define your token.
  ///
  /// [isContent] default is false. If is true, onSuccess will get the direct data of the server returned data.
  ///
  /// [isAlreadyToken] default is true, it will take the default token and throw an error when you have not default token. You should use this true after setting up the default token
  ///
  /// Below methods are overriding the existing methods that you created while instantiating class 😤
  ///
  // / [onBeforeValidate] , [onBeforeValidateSync] is to check before calling the api request eg. Checking Internet connection before request to api
  // /
  // / [isDefaultBeforeValidate] default is true that means when you does not declare above two methods, default method (i.e in the instantiated class) will be use
  // /
  // / [onAfterValidate] , [onAfterValidateSync] is to check after calling the api request eg. Checking authorized or 400 error
  // /
  // / [isDefaultAfterValidate] default is true that means when you does not declare above two methods, default method (i.e in the instantiated class) will be use
  // /
  // / [onTimeOutError], [onTimeOutErrorSync] is to catch the time out error
  // /
  // / [isDefaultTimeOutError] default is true that means when you does not declare above two methods, default method (i.e in the instantiated class) will be use
  // /
  // / [onError], [onErrorSync] are to catch the error code from server
  // /
  // / [isDefaultError] default is true that means when you does not declare above two methods, default method (i.e in the instantiated class) will be use
  // /
  Future<void> query<T>({
    required String method,
    required String path,
    required CallBackFunc<T> onSuccess,
    String? basePath,
    Map<String, dynamic>? data,
    String? contentType,
    String? token,
    bool isContent = false,
    bool isAlreadyToken = true,
    JackApiCacheOptions? cacheOptions,
    BeforeCallBackConfig<bool?>? beforeValidate,
    AfterCallBackConfig<T, bool?>? afterValidate,
    CallBackConfig? timeOutError,
    CallBackConfig? error,
  }) async {
    RestApiData.methods.setConfig(basePath, contentType);
    _checkToken(token, isAlreadyToken);
    final extra = RestApiData.methods.setUpCacheOption(cacheOptions);

    await RestApiData.methods.query<T, bool?>(
      method: method,
      path: path,
      data: data,
      isContent: isContent,
      onSuccess: onSuccess,
      beforeValidate: beforeValidate ?? BeforeCallBackConfig(),
      afterValidate: afterValidate ?? AfterCallBackConfig(),
      timeOutError: timeOutError ?? CallBackConfig(),
      error: error ?? CallBackConfig(),
      extra: extra,
      oldBeforeValidate: _onBeforeValidate,
      oldAfterValidate: _onAfterValidate,
      oldTimeOutError: _onTimeOutError,
      oldError: _onError,
    );
  }

  /// [method] is the method of API request
  ///
  /// [path] is the api endPoint
  ///
  /// [onSuccess] is the callBack function when you receive successfully the data from server
  ///
  /// [basePath] is to modify the API base path of your project
  ///
  /// [token] is optional token of your authenticated api request. If you don't want to set every time called this method, you can pr-define your token.
  ///
  /// [isContent] default is false. If is true, onSuccess will get the direct data of the server returned data.
  ///
  /// [isAlreadyToken] default is true, it will take the default token and throw an error when you have not default token. You should use this true after setting up the default token
  ///
  /// Below methods are overriding the existing methods that you created while instantiating class 😤
  ///
  // / [onBeforeValidate] , [onBeforeValidateSync] is to check before calling the api request eg. Checking Internet connection before request to api
  // /
  // / [isDefaultBeforeValidate] default is true that means when you does not declare above two methods, default method (i.e in the instantiated class) will be use
  // /
  // / [onAfterValidate] , [onAfterValidateSync] is to check after calling the api request eg. Checking authorized or 400 error
  // /
  // / [isDefaultAfterValidate] default is true that means when you does not declare above two methods, default method (i.e in the instantiated class) will be use
  // /
  // / [onTimeOutError], [onTimeOutErrorSync] is to catch the time out error
  // /
  // / [isDefaultTimeOutError] default is true that means when you does not declare above two methods, default method (i.e in the instantiated class) will be use
  // /
  // / [onError], [onErrorSync] are to catch the error code from server
  // /
  // / [isDefaultError] default is true that means when you does not declare above two methods, default method (i.e in the instantiated class) will be use
  // /
  Future<void> postWithForm<T>({
    required String method,
    required String path,
    required Map<String, dynamic> data,
    required CallBackFunc<T> onSuccess,
    JackApiCacheOptions? cacheOptions,
    String? basePath,
    List<String>? filePaths,
    String? token,
    bool isContent = false,
    bool isAlreadyToken = true,
    BeforeCallBackConfig<bool?>? beforeValidate,
    AfterCallBackConfig<T, bool?>? afterValidate,
    CallBackConfig? timeOutError,
    CallBackConfig? error,
  }) async {
    if (method.toLowerCase() == "GET".toLowerCase()) {
      printError("postWithForm does not allow with GET method ❌");
      return;
    }

    // form data
    final formData = FormData.fromMap(data);
    if (filePaths != null) {
      for (final i in filePaths) {
        final fileName = i.split("/").last;
        try {
          final file = await MultipartFile.fromFile(i, filename: fileName);
          formData.files.add(
            MapEntry(fileName, file),
          );
        } on Exception catch (_) {
          printError("Error throwing in formData from file of $i");
        }
      }
    }

    RestApiData.methods.setConfig(
      basePath,
      "multipart/form-data ; boundary=${formData.boundary}",
    );
    _checkToken(token, isAlreadyToken);
    final extra = RestApiData.methods.setUpCacheOption(cacheOptions);

    await RestApiData.methods.query<T, bool?>(
      method: method,
      path: path,
      data: formData,
      isContent: isContent,
      onSuccess: onSuccess,
      beforeValidate: beforeValidate ?? BeforeCallBackConfig(),
      afterValidate: afterValidate ?? AfterCallBackConfig(),
      timeOutError: timeOutError ?? CallBackConfig(),
      error: error ?? CallBackConfig(),
      extra: extra,
      oldBeforeValidate: _onBeforeValidate,
      oldAfterValidate: _onAfterValidate,
      oldTimeOutError: _onTimeOutError,
      oldError: _onError,
    );
  }

  Future<void> resetCache() async {
    await CacheService.resetDb();
  }

  /// This will get the size of the whole db in bytes 😅
  ///
  Future<int> cacheSize() async {
    return await CacheService.getSize();
  }

  /// [url] is the fully https url link to download media
  ///
  /// [savePath] is the fully file path including file name and extension
  ///
  /// [onTimeOutError], [onTimeOutErrorSync] is to catch the time out error
  ///
  /// [isDefaultTimeOutError] default is true that means when you does not declare above two methods, default method (i.e in the instantiated class) will be use
  ///
  /// [onError], [onErrorSync] are to catch the error code from server
  ///
  /// [isDefaultError] default is true that means when you does not declare above two methods, default method (i.e in the instantiated class) will be use
  ///
  Future<String?> download({
    required String url,
    required String savePath,
    void Function()? onTimeOutErrorSync,
    Future<void> Function()? onTimeOutError,
    bool isDefaultTimeOutError = true,
    void Function()? onErrorSync,
    Future<void> Function()? onError,
    bool isDefaultError = true,
  }) async {
    return await RestApiData.methods.download(
      url: url,
      savePath: savePath,
      onTimeOutError:
          isDefaultTimeOutError ? onTimeOutError ?? _onTimeOutError : null,
      onError: isDefaultError ? onError ?? _onError : null,
    );
  }

  void _checkToken(
    String? token,
    bool isAlreadyToken,
  ) {
    RestApiData.methods.checkToken(
      myToken,
      token,
      isAlreadyToken: isAlreadyToken,
    );
  }
}
