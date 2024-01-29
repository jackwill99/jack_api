import "dart:async";
import "dart:isolate";

import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:isar/isar.dart";
import "package:jack_api/jack_api.dart";
import "package:jack_api/src/cache/cache_model.dart";
import "package:jack_api/src/cache/isar_service.dart";
import "package:jack_api/src/util.dart";

class DataCacheService {
  final _isar = IsarService.I.isar;

  /// Public method to initialize
  Future<void> initCacheService() async {
    if (IsarService.I.isar == null) {
      await IsarService.I.initialize();
    }
  }

  Future<void> store({required DataCacheOptions options}) async {
    await _isar?.writeTxn(
      () async {
        final dataCache = DataCache()
          ..key = options.key
          ..data = options.data
          ..expires = options.expiry == null
              ? null
              : DateTime.now().add(options.expiry!)
          ..extra = options.extra;

        await _isar?.dataCaches.put(dataCache);
      },
    );
  }

  Future<String?> read({
    required String key,
    void Function(String cache)? whenExpired,
  }) async {
    final cache = await _isar?.dataCaches.filter().keyEqualTo(key).findFirst();

    if (cache == null) {
      printError("No cache data found");
      return null;
    }

    /// Cache will delete when device is connected with internet and cache data is expire
    if ((OnlineStatus.I.isOnline != null || OnlineStatus.I.isOnline!) &&
        (cache.expires != null && DateTime.now().isAfter(cache.expires!))) {
      await _isar?.writeTxn(() async {
        await _isar?.dataCaches.filter().keyEqualTo(key).deleteFirst();
      });

      whenExpired?.call(cache.data);

      return null;
    }

    return cache.data;
  }

  Future<List<String>> readAll({
    required String key,
    void Function(int id, String key, String cache)? whenExpired,
  }) async {
    final caches = await _isar?.dataCaches.filter().keyEqualTo(key).findAll();

    if (caches == null) {
      printError("No cache data found");
      return [];
    }

    final validData = <String>[];
    for (final cache in caches) {
      /// Cache will delete when device is connected with internet and cache data is expire
      if ((OnlineStatus.I.isOnline != null || OnlineStatus.I.isOnline!) &&
          (cache.expires != null && DateTime.now().isAfter(cache.expires!))) {
        await _isar?.writeTxn(() async {
          await _isar?.dataCaches.filter().keyEqualTo(key).deleteFirst();
        });

        whenExpired?.call(
          cache.id,
          cache.key,
          cache.data,
        );
      } else {
        validData.add(cache.data);
      }
    }

    return validData;
  }

  Future<void> update({
    required String key,
    required FutureOr<(String, String?)> Function(
      String data,
      String? extra,
    ) modifier,
  }) async {
    final cache = await _isar?.dataCaches.filter().keyEqualTo(key).findFirst();

    if (cache == null) {
      printError("No cache data found");
      throw "No cache data found";
    }

    final modifiedData = await modifier(
      cache.data,
      cache.extra,
    );

    cache
      ..data = modifiedData.$1
      ..extra = modifiedData.$2;

    await _isar?.writeTxn(
      () async {
        await _isar?.dataCaches.put(cache);
      },
    );
  }

  Future<void> delete({
    required String key,
  }) async {
    await _isar?.writeTxn(() async {
      await _isar?.dataCaches.filter().keyEqualTo(key).deleteFirst();
    });
  }

  static Future<void> deleteExpiredData() async {
    /// create the port to receive data from
    final resultPort = ReceivePort();
    final rootToken = RootIsolateToken.instance!;

    /// spawn a new isolate and pass down a function that will be used in a new isolate
    /// and pass down the result port that will send back the result.
    /// you can send any number of arguments.
    try {
      await Isolate.spawn(
        _calExpiredData,
        [resultPort.sendPort, rootToken],
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

    final isarService = IsarService.I;

    await isarService.isar?.writeTxn(() async {
      final count = await isarService.isar?.dataCaches
          .filter()
          .expiresIsNotNull()
          .and()
          .expiresLessThan(DateTime.now())
          .deleteAll();

      debugPrint("\x1B[31m ╔╣  ${args[2]} \x1B[0m");
      debugPrint(
        " ║   Deleted expired data of $count , Happy memory saving 😎 ✅ \x1B[0m",
      );
      debugPrint(" ╚   \x1B[0m");
    });

    Isolate.exit(resultPort, "Success ");
  }
}
