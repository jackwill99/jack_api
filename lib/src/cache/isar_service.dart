import "package:isar/isar.dart";
import "package:jack_api/src/cache/cache_model.dart";
import "package:path_provider/path_provider.dart";

class IsarService {
  IsarService._();

  static late Isar _isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ApiCacheSchema],
      directory: dir.path,
    );
  }

  static Isar get isar => _isar;
}
