import "dart:async";

import "package:dio/dio.dart";
import "package:jack_api/src/cache/cache_options.dart";
import "package:jack_api/src/jack_rest_api/model.dart";
import "package:jack_api/src/jack_rest_api/validation.dart";
import "package:jack_api/src/util.dart";

class JackApiMethods {
  JackApiMethods({
    required this.baseUrl,
  });

  String baseUrl;

  Future<Response?> query<T, R>({
    required String method,
    required String path,
    required bool isContent,
    required Dio dio,
    required CallBackFunc<T> onSuccess,
    required BeforeCallBackConfig<bool?> beforeValidate,
    required AfterCallBackConfig<T, bool?> afterValidate,
    required CallBackConfig timeOutError,
    required CallBackConfig error,
    CacheOptionsStatus? extra,
    dynamic data,
    CallBackWithReturn? oldBeforeValidate,
    CallBack? oldAfterValidate,
    CallBackNoArgs? oldTimeOutError,
    CallBackNoArgs? oldError,
  }) async {
    if (!await checkBeforeValidate(
      beforeValidate: beforeValidate,
      oldBeforeValidate: oldBeforeValidate,
    )) {
      return null;
    }

    // start to call api request
    try {
      final Response response = await _dioMethod(
        dio: dio,
        name: method,
        path: path,
        extra: extra,
        data: data,
      );

      if (isContent) {
        await onSuccess(response.data);
      }

      final responseData = response.data as T;

      if (!await checkAfterValidate<T>(
        data: responseData,
        afterValidate: afterValidate,
        oldAfterValidate: oldAfterValidate,
      )) {
        return null;
      }

      await onSuccess(responseData);

      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        await checkTimeOut(
          timeOutError: timeOutError,
          oldTimeOutError: oldTimeOutError,
        );
      } else {
        printError("Dio Excepition error -->");
        await checkError(error: error, oldError: oldError);
        rethrow;
      }
    }
    return null;
  }

  static Future<String?> download({
    required String url,
    required String savePath,
    required Dio dio,
    void Function(double progress)? onProgress,
    FutureOr<void> Function()? onTimeOutError,
    FutureOr<void> Function()? onError,
  }) async {
    try {
      await dio.download(
        url,
        savePath,
        onReceiveProgress: onProgress == null
            ? null
            : (received, total) {
                final progress = (received / total) * 100;
                onProgress(progress);
              },
      );
      return savePath;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        await onTimeOutError?.call();
      } else {
        printError("Dio Exception error -->");
        await onError?.call();
      }
    }
    return null;
  }

  CacheOptionsStatus setUpCacheOption(
    JackApiCacheOptions? value,
    StreamController<bool>? cacheStatusStream,
  ) {
    if (value == null) {
      return CacheOptionsStatus(cacheEnable: false, schemaName: "");
    } else {
      return CacheOptionsStatus(
        cacheEnable: true,
        schemaName: value.schemaName,
        isForceRefresh: value.isForceRefresh,
        allowPostMethod: value.allowPostMethod,
        duration: value.duration,
        cacheStatusStream: cacheStatusStream,
      );
    }
  }

  void changeContentType(
    Dio dio,
    String? contentType,
  ) {
    if (contentType != null) {
      dio.options.headers["Content-Type"] = contentType;
    } else {
      dio.options.headers["Content-Type"] = "application/json";
    }
  }

  void setXSignatureHeader(
    Dio dio,
    String? calculatedHmac,
  ) {
    if (calculatedHmac != null) {
      dio.options.headers["x-signature"] = calculatedHmac;
    }
  }

  void checkToken(
    String? previousToken,
    String? newToken,
    String? tokenKey, {
    required Dio dio,
    required bool isAlreadyToken,
  }) {
    if (isAlreadyToken) {
      if (newToken != null) {
        dio.options.headers[tokenKey ?? "Authorization"] =
            "${tokenKey == null ? "Bearer " : ""}$newToken";
      } else if (previousToken == null) {
        printError(
          "You have no already token. Set up your token before calling this API ! 😅",
        );
        throw "Error Throwing : you have no token";
      } else {
        dio.options.headers[tokenKey ?? "Authorization"] =
            "${tokenKey == null ? "Bearer " : ""}$previousToken";
      }
    } else {
      if (newToken == null) {
        printError(
          "You are calling the un-authenticated public API. You have no token.",
        );
      } else {
        dio.options.headers[tokenKey ?? "Authorization"] =
            "${tokenKey == null ? "Bearer " : ""}$newToken";
      }
    }
  }

  Future<Response> _dioMethod({
    required String name,
    required String path,
    required Dio dio,
    CacheOptionsStatus? extra,
    dynamic data,
  }) async {
    final options = Options().copyWith(
      extra: extra?.toMap(),
    );
    switch (name) {
      case "GET":
        return await dio.get(
          path,
          options: options,
        );
      case "POST":
        return await dio.post(
          path,
          data: data,
          options: options,
        );
      case "PUT":
        return await dio.put(
          path,
          data: data,
          options: options,
        );
      case "DELETE":
        return await dio.delete(
          path,
          options: options,
          data: data,
        );
      default:
        throw "Error Throwing : API method does not correct. Use all capital letter";
    }
  }
}
