import "dart:convert";

import "package:dio/dio.dart";
import "package:jack_api/jack_api.dart";
import "package:jack_api/src/cache/cache_service.dart";

class CacheInterceptor extends Interceptor {
  CacheInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final extra = options.extra;

    if (RestApiData.isOnline == null || RestApiData.isOnline!) {
      /// Situation of caching
      /// - enable cache (and)
      /// - not isForceRefresh (and)
      /// - ( get method (or)
      /// - not get method (and) allow post method )
      if (!(extra["enableCache"] as bool) ||
          (extra["isForceRefresh"] as bool) ||
          (options.method != "GET" && !(extra["allowPostMethod"] as bool))) {
        handler.next(options);
        return;
      }
    }

    final cache = await CacheService.get(
      key: options.uri.toString(),
      schemaName: extra["schemaName"],
      isImage: extra["isImage"],
      postData: (options.method != "GET" && (extra["allowPostMethod"] as bool))
          ? options.data
          : null,
    );
    if (cache == null) {
      handler.next(options);
      return;
    }
    handler.resolve(
      Response(
        requestOptions: options,
        headers: _getHeaders(cache.headers),
        statusCode: cache.statusCode,
        data: jsonDecode(cache.data!),
      ),
    );
  }

  Headers _getHeaders(data) {
    final Map<String, dynamic> headersE = jsonDecode(data);
    final headers =
        headersE.map((key, value) => MapEntry(key, List<String>.from(value)));
    return Headers.fromMap(headers);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    final extra = response.requestOptions.extra;

    if (!(extra["enableCache"] as bool) ||
        (response.requestOptions.method != "GET" &&
            !(extra["allowPostMethod"] as bool))) {
      handler.next(response);
      return;
    }
    await CacheService.store(
      response,
      extra["schemaName"],
      extra["duration"],
      (response.requestOptions.method != "GET" &&
              (extra["allowPostMethod"] as bool))
          ? response.requestOptions.data
          : null,
    );
    handler.next(response);
  }
}
