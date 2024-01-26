import "dart:async";
import "dart:convert";

import "package:dio/dio.dart";
import "package:jack_api/src/cache/cache_options.dart";
import "package:jack_api/src/cache/cache_service.dart";
import "package:jack_api/src/cache/isar_service.dart";
import "package:jack_api/src/jack_rest_api/model.dart";

class CacheInterceptor extends Interceptor {
  CacheInterceptor();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (IsarService.I.isar == null) {
      handler.next(options);
      return;
    }

    final extra = CacheOptionsStatus.fromMap(options.extra);
    final postDataOptions = (options.method != "GET" && (extra.allowPostMethod))
        ? options.data
        : null;

    if (OnlineStatus.I.isOnline != null && OnlineStatus.I.isOnline!) {
      /// Situation of caching
      /// - enable cache (and)
      /// - not isForceRefresh (and)
      /// - ( get method (or)
      /// - not get method (and) allow post method )
      if (!(extra.cacheEnable) ||
          (extra.isForceRefresh) ||
          (options.method != "GET" && !(extra.allowPostMethod))) {
        unawaited(
          CacheService.searchAndDelete(
            options.uri.toString(),
            postDataOptions,
          ),
        );

        extra.cacheStatusStream?.add(false);
        handler.next(options);
        return;
      }
    }

    final cache = await CacheService.get(
      key: options.uri.toString(),
      schemaName: extra.schemaName,
      postData: postDataOptions,
    );
    if (cache == null) {
      extra.cacheStatusStream?.add(false);
      handler.next(options);
      return;
    }
    extra.cacheStatusStream?.add(true);
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
    if (IsarService.I.isar == null) {
      handler.next(response);
      return;
    }

    final extra = CacheOptionsStatus.fromMap(response.requestOptions.extra);

    if (!(extra.cacheEnable) ||
        (response.requestOptions.method != "GET" && !(extra.allowPostMethod))) {
      handler.next(response);
      return;
    }
    if (response.statusCode == 200) {
      await CacheService.store(
        response,
        extra.schemaName,
        extra.duration,
        (response.requestOptions.method != "GET" && (extra.allowPostMethod))
            ? response.requestOptions.data
            : null,
      );
    }
    handler.next(response);
  }
}
