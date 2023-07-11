import "dart:async";
import "dart:convert";
import "dart:isolate";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
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
    final isar = IsarService.isar;
    await isar.writeTxn(
      () async => isar.apiCaches.putByKey(
        ApiCache()
          ..key = response.requestOptions.uri.toString()
          ..data = jsonEncode(response.data)
          ..expires = DateTime.now().add(expires)
          ..statusCode = response.statusCode
          ..headers = jsonEncode(response.headers.map)
          ..schemeName = schemaName,
      ),
    );
  }

  static Future<ApiCache?> get({
    required String key,
    required String schemaName,
    bool isImage = false,
  }) async {
    final isar = IsarService.isar;
    final cache = await isar.apiCaches.getByKey(key);
    if (cache == null) {
      return null;
    }

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

    /// Cache will delete when device is connected with internet and cache data is expire
    if ((RestApiData.isOnline == null || RestApiData.isOnline!) &&
        DateTime.now().isAfter(cache.expires)) {
      await isar.writeTxn(() async => await isar.apiCaches.deleteByKey(key));
      return null;
    }

    debugPrint("╔  Jack Api Cache 🚀 👨🏻‍💻");
    debugPrint("║  This data comes from api cache. (302)");
    debugPrint(
      "║\x1B[31m If you need to re-fresh the data, set isForceRefresh to true or delete api schema 🫡 \x1B[0m",
    );
    debugPrint("╚  ");
    return cache;
  }

  static Future<void> _removeExpiredData(String schemaName) async {
    unawaited(compute<String, void>(_calExpiredData, schemaName));
  }

  /// function that will be executed in the new isolate
  static Future<void> _calExpiredData(String schemaName) async {
    final count = await IsarService.isar.apiCaches
        .filter()
        .schemeNameEqualTo(schemaName)
        .and()
        .expiresLessThan(DateTime.now())
        .deleteAll();
    debugPrint("\x1B[31m ╔  Delete expired data of $schemaName \x1B[0m");
    debugPrint("\x1B[31m ║  $count , Happy memory saving 😎 ✅ \x1B[0m");
    debugPrint("\x1B[31m ╚  \x1B[0m");
  }

  // ------------------------------------

  @Deprecated("Change to compute method operation")
  static Future<void> _removeExpiredDataDeprecated() async {
    /// create the port to receive data from
    final resultPort = ReceivePort();

    /// spawn a new isolate and pass down a function that will be used in a new isolate
    /// and pass down the result port that will send back the result.
    /// you can send any number of arguments.

    try {
      await Isolate.spawn(
        _readAndParseJson,
        [resultPort.sendPort],
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
    }
  }

  /// we create a top-level function that specifically uses the args
  /// which contain the send port. This send port will actually be used to
  /// communicate the result back to the main isolate
  /// This function should have been isolate-agnostic
  static Future<void> _readAndParseJson(List<dynamic> args) async {
    final SendPort resultPort = args[0];

    await Future.delayed(const Duration(seconds: 2));

    Isolate.exit(resultPort, "Success ");
  }
}
