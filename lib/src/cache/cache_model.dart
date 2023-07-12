import "package:isar/isar.dart";

part "cache_model.g.dart";

@collection
class ApiCache {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String key;
  @Index()
  late String schemeName;
  @Index()
  String? postData;
  String? data;
  late String headers;
  int? statusCode;
  late DateTime expires;
}
