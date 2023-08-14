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
