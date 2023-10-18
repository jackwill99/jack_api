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
    _isUseHttp2 = useHttp2;
    _baseUrl = baseUrl;
    _connectTimeout = connectTimeout;

    _onBeforeValidate = onBeforeValidate;
    _onAfterValidate = onAfterValidate;
    _onTimeOutError = onTimeOutError;
    _onError = onError;

    _init(
      baseUrl: baseUrl,
    );
  }

  JackRestApi copyWith({
    String? baseUrl,
    int? connectTimeout,
    Future<bool> Function()? onBeforeValidate,
    CallBack? onAfterValidate,
    Future<void> Function()? onTimeOutError,
    Future<void> Function()? onError,
    bool? useHttp2,
  }) =>
      JackRestApi(
        baseUrl: baseUrl ?? _baseUrl,
        connectTimeout: connectTimeout ?? _connectTimeout,
        useHttp2: useHttp2 ?? _isUseHttp2,
        onBeforeValidate: onBeforeValidate ?? _onBeforeValidate,
        onAfterValidate: onAfterValidate ?? _onAfterValidate,
        onTimeOutError: onTimeOutError ?? _onTimeOutError,
        onError: onError ?? _onError,
      );

  late bool _isUseHttp2;
  int? _connectTimeout;
  late String _baseUrl;
  String? _token;
  late RestApiData _restApiData;

  /// Dio client
  late Dio dio;

  CallBackWithReturn? _onBeforeValidate;

  CallBack? _onAfterValidate;

  CallBackNoArgs? _onTimeOutError;

  CallBackNoArgs? _onError;

  String? get myToken => _token;

  /// Public method to initialize
  Future<void> init() async {
    await GetIt.I.registerSingleton(IsarService()).initialize();
  }

  /// Public method to store token value
  set myToken(String? value) {
    _token = value;
    _restApiData.token = value;

    if (value != null) {
      _restApiData.dio.options.headers["Authorization"] = "Bearer $myToken";
    } else {
      _restApiData.dio.options.headers.remove("Authorization");
    }
  }

  /// Public method to change internet connection
  void setIsOnline({bool? value}) {
    OnlineStatus.I.isOnline = value;
  }

  void _init({
    required String baseUrl,
  }) {
    final connectionTimeout = _connectTimeout == null
        ? const Duration(seconds: 20)
        : Duration(seconds: _connectTimeout!);
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectionTimeout,
      ),
    )..options.headers["Content-Type"] = "application/json";

    if (_isUseHttp2) {
      dio.httpClientAdapter = Http2Adapter(
        ConnectionManager(
          idleTimeout: connectionTimeout,
          onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
        ),
      );
    }

    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
        ),
      );
    }
    dio.interceptors.add(
      CacheInterceptor(),
    );
    final methods = JackApiMethods(baseUrl: baseUrl);

    _restApiData = RestApiData(dio: dio, methods: methods);
  }

  /// [method] is the method of API request
  ///
  /// [path] is the api endPoint
  ///
  /// [onSuccess] is the callBack function when you receive successfully the data from server
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
    final tempDio = dio;
    _restApiData.methods.changeContentType(
      tempDio,
      null,
    );
    _checkToken(tempDio, token, isAlreadyToken);
    final extra = _restApiData.methods.setUpCacheOption(cacheOptions);

    await _restApiData.methods.query<T, bool?>(
      method: method,
      path: path,
      data: data,
      isContent: isContent,
      dio: tempDio,
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

    final tempDio = dio;
    _restApiData.methods.changeContentType(
      tempDio,
      "multipart/form-data ; boundary=${formData.boundary}",
    );
    _checkToken(tempDio, token, isAlreadyToken);
    final extra = _restApiData.methods.setUpCacheOption(cacheOptions);

    await _restApiData.methods.query<T, bool?>(
      method: method,
      path: path,
      data: formData,
      isContent: isContent,
      dio: dio,
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
  /// [onTimeOutError] is to catch the time out error
  ///
  /// [onError] are to catch the error code from server
  ///
  ///
  Future<String?> download({
    required String url,
    required String savePath,
    void Function(double progress)? onReceiveProgress,
    FutureOr<void> Function()? onTimeOutError,
    FutureOr<void> Function()? onError,
  }) async {
    final tempDio = Dio();
    return await _restApiData.methods.download(
      url: url,
      savePath: savePath,
      dio: tempDio,
      onProgress: onReceiveProgress,
      onTimeOutError: onTimeOutError ?? _onTimeOutError,
      onError: onError ?? _onError,
    );
  }

  void _checkToken(
    Dio tempDio,
    String? token,
    bool isAlreadyToken,
  ) {
    _restApiData.methods.checkToken(
      myToken,
      token,
      isAlreadyToken: isAlreadyToken,
      dio: tempDio,
    );
  }
}
