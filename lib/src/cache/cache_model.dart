import "package:isar/isar.dart";

part "cache_model.g.dart";

@collection
class ApiCache {
  Id id = Isar.autoIncrement;
  late String key;
  @Index()
  late String schemeName;
  @Index()
  int? bodyHash;
  String? data;
  late String headers;
  int? statusCode;
  late DateTime expires;
}

@collection
class DataCache {
  Id id = Isar.autoIncrement;
  @Index()
  late String key;
  late String data;
  String? extra;
  DateTime? expires;
}
