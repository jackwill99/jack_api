import "package:dio/dio.dart";
import "package:jack_api/src/jack_rest_api/dio_methods.dart";
import "package:jack_api/src/util.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";

class JackRestApi {
  /// ### Config while instantiating class
  ///
  /// [baseUrl] is the main base url
  ///
  /// [connectTimeout] is in seconds of time and default is 20 seconds.
  ///
  ///
  JackRestApi({
    required String baseUrl,
    int? connectTimeout,
    bool Function()? onBeforeValidateSync,
    Future<bool> Function()? onBeforeValidate,
    AfterCallBackSync? onAfterValidateSync,
    AfterCallBack? onAfterValidate,
    void Function()? onTimeOutErrorSync,
    Future<void> Function()? onTimeOutError,
    void Function()? onErrorSync,
    Future<void> Function()? onError,
  }) {
    _init(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
    );

    _onBeforeValidate = onBeforeValidate;
    _onBeforeValidateSync = onBeforeValidateSync;

    _onAfterValidateSync = onAfterValidateSync;
    _onAfterValidate = onAfterValidate;

    _onTimeOutError = onTimeOutError;
    _onTimeOutErrorSync = onTimeOutErrorSync;

    _onError = onError;
    _onErrorSync = onErrorSync;
  }

  late Dio _dio;
  late JackApiMethods _methods;

  String? _token;
  String? get myToken => _token;
  set myToken(String? value) {
    _token = value;
    if (value != null) {
      _dio.options.headers["Authorization"] = "Bearer $myToken";
    }
  }

  bool Function()? _onBeforeValidateSync;
  Future<bool> Function()? _onBeforeValidate;

  AfterCallBackSync? _onAfterValidateSync;
  AfterCallBack? _onAfterValidate;

  void Function()? _onTimeOutErrorSync;
  Future<void> Function()? _onTimeOutError;

  void Function()? _onErrorSync;
  Future<void> Function()? _onError;

  void _init({
    required String baseUrl,
    int? connectTimeout,
  }) {
    final connectionTimeout = connectTimeout == null
        ? const Duration(seconds: 20)
        : Duration(seconds: connectTimeout);
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectionTimeout,
      ),
    );
    _dio.options.headers["Content-Type"] = "application/json";
    // _dio.httpClientAdapter = Http2Adapter(
    //   ConnectionManager(
    //     idleTimeout: connectionTimeout,
    //     onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
    //   ),
    // );
    _dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
      ),
    );
    _methods = JackApiMethods(baseUrl: baseUrl, dio: _dio);
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
  /// [onBeforeValidate] , [onBeforeValidateSync] is to check before calling the api request eg. Checking Internet connection before request to api
  ///
  /// [onAfterValidate] , [onAfterValidateSync] is to check after calling the api request eg. Checking authorized or 400 error
  ///
  /// [onTimeOutError], [onTimeOutErrorSync] is to catch the time out error
  ///
  /// [onError], [onErrorSync] are to catch the error code from server
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
    bool Function()? onBeforeValidateSync,
    Future<bool> Function()? onBeforeValidate,
    AfterCallBackSync? onAfterValidateSync,
    AfterCallBack? onAfterValidate,
    void Function()? onTimeOutErrorSync,
    Future<void> Function()? onTimeOutError,
    void Function()? onErrorSync,
    Future<void> Function()? onError,
  }) async {
    _methods.setConfig(basePath, contentType);
    _checkToken(token, isAlreadyToken);

    await _methods.query<T>(
      method: method,
      path: path,
      data: data,
      isContent: isContent,
      onSuccess: onSuccess,
      onBeforeValidate: onBeforeValidate ?? _onBeforeValidate,
      onBeforeValidateSync: onBeforeValidateSync ?? _onBeforeValidateSync,
      onAfterValidate: onAfterValidate ?? _onAfterValidate,
      onAfterValidateSync: onAfterValidateSync ?? _onAfterValidateSync,
      onTimeOutError: onTimeOutError ?? _onTimeOutError,
      onTimeOutErrorSync: onTimeOutErrorSync ?? _onTimeOutErrorSync,
      onError: onError ?? _onError,
      onErrorSync: onErrorSync ?? _onErrorSync,
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
  /// [onBeforeValidate] , [onBeforeValidateSync] is to check before calling the api request eg. Checking Internet connection before request to api
  ///
  /// [onAfterValidate] , [onAfterValidateSync] is to check after calling the api request eg. Checking authorized or 400 error
  ///
  /// [onTimeOutError], [onTimeOutErrorSync] is to catch the time out error
  ///
  /// [onError], [onErrorSync] are to catch the error code from server
  Future<void> postWithForm<T>({
    required String method,
    required String path,
    required Map<String, dynamic> data,
    required CallBackFunc<T> onSuccess,
    String? basePath,
    List<String>? filePaths,
    String? token,
    bool isContent = false,
    bool isAlreadyToken = true,
    bool Function()? onBeforeValidateSync,
    Future<bool> Function()? onBeforeValidate,
    AfterCallBackSync? onAfterValidateSync,
    AfterCallBack? onAfterValidate,
    void Function()? onTimeOutErrorSync,
    Future<void> Function()? onTimeOutError,
    void Function()? onErrorSync,
    Future<void> Function()? onError,
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
        final file = await MultipartFile.fromFile(i, filename: fileName);
        formData.files.add(
          MapEntry(fileName, file),
        );
      }
    }

    _methods.setConfig(
      basePath,
      "multipart/form-data ; boundary=${formData.boundary}",
    );
    _checkToken(token, isAlreadyToken);

    await _methods.query<T>(
      method: method,
      path: path,
      data: data,
      isContent: isContent,
      onSuccess: onSuccess,
      onBeforeValidate: onBeforeValidate ?? _onBeforeValidate,
      onBeforeValidateSync: onBeforeValidateSync ?? _onBeforeValidateSync,
      onAfterValidate: onAfterValidate ?? _onAfterValidate,
      onAfterValidateSync: onAfterValidateSync ?? _onAfterValidateSync,
      onTimeOutError: onTimeOutError ?? _onTimeOutError,
      onTimeOutErrorSync: onTimeOutErrorSync ?? _onTimeOutErrorSync,
      onError: onError ?? _onError,
      onErrorSync: onErrorSync ?? _onErrorSync,
    );
  }

  void _checkToken(
    String? token,
    bool isAlreadyToken,
  ) {
    _methods.checkToken(
      myToken,
      token,
      isAlreadyToken: isAlreadyToken,
    );
  }
}
