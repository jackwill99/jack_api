import "dart:async";

import "package:get_it/get_it.dart";
import "package:isar/isar.dart";
import "package:jack_api/jack_api.dart";
import "package:jack_api/src/cache/cache_model.dart";
import "package:jack_api/src/cache/cache_service.dart";
import "package:jack_api/src/cache/isar_service.dart";
import "package:jack_api/src/util.dart";

class DataCacheService {
  factory DataCacheService() {
    return I;
  }

  DataCacheService._();

  static final DataCacheService I = DataCacheService._();

  final _isar = GetIt.instance<IsarService>().isar;

  Future<void> store({required DataCacheOptions options}) async {
    await _isar.writeTxn(
      () async {
        final dataCache = DataCache()
          ..key = options.key
          ..data = options.data
          ..expires = DateTime.now().add(options.expiry)
          ..schemeName = options.schemaName;

        await _isar.dataCaches.put(dataCache);
      },
    );
  }

  Future<String?> read({
    required String key,
    required String schemaName,
    void Function(String cache)? whenExpired,
  }) async {
    if ((OnlineStatus.I.isOnline == null || OnlineStatus.I.isOnline!) &&
        !CacheService.schemaList.contains(schemaName)) {
      /// run isolate and remove old expire data
      unawaited(CacheService.removeExpiredData(schemaName));

      /// add schema list
      CacheService.schemaList.add(schemaName);
    }

    final cache = await _isar.dataCaches
        .filter()
        .keyEqualTo(key)
        .and()
        .schemeNameEqualTo(schemaName)
        .findFirst();

    if (cache == null) {
      printError("No cache data found");
      return null;
    }

    /// Cache will delete when device is connected with internet and cache data is expire
    if ((OnlineStatus.I.isOnline == null || OnlineStatus.I.isOnline!) &&
        DateTime.now().isAfter(cache.expires)) {
      await _isar.writeTxn(() async {
        await _isar.dataCaches
            .filter()
            .keyEqualTo(key)
            .and()
            .schemeNameEqualTo(schemaName)
            .deleteFirst();
      });

      whenExpired?.call(cache.data);

      return null;
    }

    return cache.data;
  }

  Future<void> update({
    required String key,
    required String schemaName,
    required String data,
  }) async {
    final cache = await _isar.dataCaches
        .filter()
        .keyEqualTo(key)
        .and()
        .schemeNameEqualTo(schemaName)
        .findFirst();

    if (cache == null) {
      printError("No cache data found");
      throw "No cache data found";
    }

    cache.data = data;

    await _isar.writeTxn(
      () async {
        await _isar.dataCaches.put(cache);
      },
    );
  }

  Future<void> delete({
    required String key,
    required String schemaName,
  }) async {
    await _isar.writeTxn(() async {
      await _isar.dataCaches
          .filter()
          .keyEqualTo(key)
          .and()
          .schemeNameEqualTo(schemaName)
          .deleteFirst();
    });
  }
}