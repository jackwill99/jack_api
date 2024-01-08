import "package:flutter/foundation.dart";
import "package:isar/isar.dart";
import "package:jack_api/src/cache/cache_model.dart";
import "package:path_provider/path_provider.dart";



class IsarService {
  factory IsarService() {
    return I;
  }

  IsarService._();

  static final IsarService I = IsarService._();

  Isar? _isar;

  Future<void> initialize({String instanceName = "jack_will"}) async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ApiCacheSchema, DataCacheSchema],
      directory: dir.path,
      name: instanceName,
      // ignore: avoid_redundant_argument_values, avoid_bool_literals_in_conditional_expressions
      inspector: kDebugMode ? true : false,
    );
  }

  Isar? get isar  => _isar;
}
