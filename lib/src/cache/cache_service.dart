import "dart:async";
import "dart:convert";
import "dart:isolate";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:get_it/get_it.dart";
import "package:isar/isar.dart";
import "package:jack_api/jack_api.dart";
import "package:jack_api/src/cache/cache_model.dart";
import "package:jack_api/src/cache/isar_service.dart";

class CacheService {
  CacheService._();

  /// This is the list schema that checked expire and removed
  /// When user opened the first time, isolate will check the expire data by schema.
  /// So, if the user goes offline without fetching other schema, they will still remain 😎
  static List<String> schemaList = [];

  static Future<void> store(
    Response response,
    String schemaName,
    Duration expires,
  ) async {
    final isar = GetIt.instance<IsarService>().isar;

    await isar.writeTxn(
      () async => isar.apiCaches.putByKey(
        ApiCache()
          ..key = response.requestOptions.uri.toString()
          ..data = jsonEncode(response.data)
          ..expires = DateTime.now().add(expires)
          ..statusCode = response.statusCode

          /// remove Authorization in cache header
          ..headers = jsonEncode(response.headers.map..remove("Authorization"))
          ..schemeName = schemaName,
      ),
    );
  }

  static Future<ApiCache?> get({
    required String key,
    required String schemaName,
    bool isImage = false,
  }) async {
    final isar = GetIt.instance<IsarService>().isar;

    /// One of the day, user reached the query with limit 10 and page 200. but user can't reach this limit and page in other days again.
    /// In this situation, we need to delete old page queries. So, i decided to check every time user first opened
    if ((RestApiData.isOnline == null || RestApiData.isOnline!) &&
        !isImage &&
        !schemaList.contains(schemaName)) {
      /// run isolate and remove old expire data
      unawaited(_removeExpiredData(schemaName));

      /// add schema list
      schemaList.add(schemaName);
    }

    final cache = await isar.apiCaches.getByKey(key);
    if (cache == null) {
      return null;
    }

    /// Cache will delete when device is connected with internet and cache data is expire
    if ((RestApiData.isOnline == null || RestApiData.isOnline!) &&
        DateTime.now().isAfter(cache.expires)) {
      await isar.writeTxn(() async => await isar.apiCaches.deleteByKey(key));
      return null;
    }

    debugPrint("╔╣  Jack Api Cache 🚀 👨🏻‍💻");
    debugPrint("║   This data comes from api cache. (302)");
    debugPrint(
      "║\x1B[31m   If you need to re-fresh the data, set isForceRefresh to true or delete api schema 🫡 \x1B[0m",
    );
    debugPrint("╚  ");
    return cache;
  }

  static Future<void> _removeExpiredData(String schemaName) async {
    /// create the port to receive data from
    final resultPort = ReceivePort();
    final rootToken = RootIsolateToken.instance!;

    /// spawn a new isolate and pass down a function that will be used in a new isolate
    /// and pass down the result port that will send back the result.
    /// you can send any number of arguments.
    try {
      await Isolate.spawn(
        _calExpiredData,
        [resultPort.sendPort, rootToken, schemaName],
        errorsAreFatal: true,
        onExit: resultPort.sendPort,
        onError: resultPort.sendPort,
      );
    } catch (_) {
      /// check if sending the entrypoint to the new isolate failed.
      /// If it did, the result port won’t get any message, and needs to be closed
      resultPort.close();
    }

    final response = await resultPort.first;
    if (response == null) {
      /// this means the isolate exited without sending any results
    } else {
      debugPrint(
        "-----response Isolate-----------------$response----------------------",
      );
    }
  }

  /// we create a top-level function that specifically uses the args
  /// which contain the send port. This send port will actually be used to
  /// communicate the result back to the main isolate
  /// This function should have been isolate-agnostic
  static Future<void> _calExpiredData(List<dynamic> args) async {
    final SendPort resultPort = args[0];
    BackgroundIsolateBinaryMessenger.ensureInitialized(args[1]);

    final isarService =
        GetIt.I.registerSingleton(IsarService(), instanceName: "isolateIsar");

    await isarService.initialize();

    await isarService.isar.writeTxn(() async {
      final count = await isarService.isar.apiCaches
          .filter()
          .schemeNameEqualTo(args[2])
          .and()
          .expiresLessThan(DateTime.now())
          .deleteAll();

      debugPrint("\x1B[31m ╔╣  Deleted expired data of ${args[2]} \x1B[0m");
      debugPrint("\x1B[31m ║   $count , Happy memory saving 😎 ✅ \x1B[0m");
      debugPrint("\x1B[31m ╚   \x1B[0m");
    });

    GetIt.I.unregister<IsarService>(instanceName: "isolateIsar");

    Isolate.exit(resultPort, "Success ");
  }
}
