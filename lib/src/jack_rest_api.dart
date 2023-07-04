import "package:dio/dio.dart";
import "package:jack_api/src/jack_rest_api/dio_methods.dart";
import "package:jack_api/src/util.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";

class JackRestApi {
  JackRestApi({
    required String baseUrl,
    int? connectTimeout,
    bool Function()? onBeforeValidateSync,
    Future<bool> Function()? onBeforeValidate,
    CallBackFuncSync? onAfterValidateSync,
    CallBackFunc? onAfterValidate,
    void Function()? onTimeOutValidateSync,
    Future<void> Function()? onTimeOutValidate,
  }) {
    _init(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
    );

    _onAfterValidate = onAfterValidate;
    _onAfterValidateSync = onAfterValidateSync;

    _onBeforeValidate = onBeforeValidate;
    _onBeforeValidateSync = onBeforeValidateSync;

    _onTimeOutValidate = onTimeOutValidate;
    _onTimeOutValidateSync = onTimeOutValidateSync;
  }

  bool Function()? _onBeforeValidateSync;
  Future<bool> Function()? _onBeforeValidate;

  CallBackFunc? _onAfterValidate;
  CallBackFuncSync? _onAfterValidateSync;

  void Function()? _onTimeOutValidateSync;
  Future<void> Function()? _onTimeOutValidate;

  String? _token;
  String? get myToken => _token;
  set myToken(String? value) {
    _token = value;
    if (value != null) {
      _dio.options.headers["Authorization"] = "Bearer $myToken";
    }
  }

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

  late Dio _dio;
  late JackApiMethods _methods;

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
    CallBackFuncSync? onAfterValidateSync,
    CallBackFunc? onAfterValidate,
    void Function()? onTimeOutValidateSync,
    Future<void> Function()? onTimeOutValidate,
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
      onTimeOutValidate: onTimeOutValidate ?? _onTimeOutValidate,
      onTimeOutValidateSync: onTimeOutValidateSync ?? _onTimeOutValidateSync,
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
    CallBackFuncSync? onAfterValidateSync,
    CallBackFunc? onAfterValidate,
    void Function()? onTimeOutValidateSync,
    Future<void> Function()? onTimeOutValidate,
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
      onTimeOutValidate: onTimeOutValidate ?? _onTimeOutValidate,
      onTimeOutValidateSync: onTimeOutValidateSync ?? _onTimeOutValidateSync,
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
