import "package:isar/isar.dart";
import "package:jack_api/src/cache/cache_model.dart";
import "package:path_provider/path_provider.dart";

class IsarService {
  Isar? _isar;

  Future<void> initialize({String instanceName = "jack_will"}) async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [ApiCacheSchema],
      directory: dir.path,
      name: instanceName,
    );
  }

  Isar get isar => _isar!;
}
