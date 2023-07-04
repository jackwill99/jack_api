import "package:dio/dio.dart";
import "package:jack_api/src/util.dart";

class JackApiMethods {
  JackApiMethods({
    required this.baseUrl,
    required this.dio,
  });

  String baseUrl;
  Dio dio;

  Future<void> query<T>({
    required String method,
    required String path,
    required bool isContent,
    required CallBackFunc<T> onSuccess,
    Map<String, dynamic>? data,
    bool Function()? onBeforeValidateSync,
    Future<bool> Function()? onBeforeValidate,
    CallBackFuncSync? onAfterValidateSync,
    CallBackFunc? onAfterValidate,
    void Function()? onTimeOutValidateSync,
    Future<void> Function()? onTimeOutValidate,
  }) async {
    bool isGetMethod = false;
    // checking the query method
    if (method.toLowerCase() == "GET".toLowerCase()) {
      isGetMethod = true;
    }
    if (method.toLowerCase() != "GET".toLowerCase() && data == null) {
      printError("You need data to send server 🥹");
      throw "Error Throwing : You need data to send server 🥹";
    }

    if (onBeforeValidate != null && !await onBeforeValidate()) {
      printError("onBeforeValidate is false");
      return;
    }
    if (onBeforeValidateSync != null && !onBeforeValidateSync()) {
      printError("onBeforeValidate is false");
      return;
    }

    // start to call api request
    try {
      final Response response = await _dioMethod(
        name: method,
        path: path,
        data: isGetMethod ? null : data,
      );

      if (isContent) {
        await onSuccess(response.data);
      }

      final responseData = response.data as T;

      onAfterValidateSync?.call(responseData);
      await onAfterValidate?.call(responseData);

      await onSuccess(responseData);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        await onTimeOutValidate?.call();
        onTimeOutValidateSync?.call();
      } else {
        printError(e.message ?? "Dio Excepition error -->");
        throw "Error Throwing : Jack Rest API Get Method";
      }
    }
  }

  void setConfig(
    String? basePath,
    String? contentType,
  ) {
    if (contentType != null) {
      dio.options.headers["Content-Type"] = contentType;
    } else {
      dio.options.headers["Content-Type"] = "application/json";
    }

    if (basePath == null) {
      dio.options.baseUrl = baseUrl;
    } else {
      dio.options.baseUrl = basePath;
    }
  }

  void checkToken(
    String? alreadyToken,
    String? newToken, {
    required bool isAlreadyToken,
  }) {
    if (isAlreadyToken) {
      if (alreadyToken == null) {
        printError(
          "You have no already token. Set up your token before calling this API ! 😅",
        );
        throw "Error Throwing : you have no token";
      } else {
        dio.options.headers["Authorization"] = "Bearer $alreadyToken";
      }
    } else {
      if (newToken == null) {
        printError(
          "You are calling the un-authenticated public API. You have no token.",
        );
      } else {
        dio.options.headers["Authorization"] = "Bearer $newToken";
      }
    }
  }

  Future<Response> _dioMethod({
    required String name,
    required String path,
    Map<String, dynamic>? data,
  }) async {
    switch (name) {
      case "GET":
        return await dio.get(path, data: data);
      case "POST":
        return await dio.post(path, data: data);
      case "PUT":
        return await dio.put(path, data: data);
      default:
        throw "Error Throwing : API method does not correct. Use all capital letter";
    }
  }
}
