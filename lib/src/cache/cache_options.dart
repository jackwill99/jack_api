// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:isar/isar.dart";

class JackApiCacheOptions {
  JackApiCacheOptions({
    required this.schemaName,
    this.allowPostMethod = false,
    this.isImage = false,
    this.isForceRefresh = false,
    this.duration = const Duration(hours: 2),
  }) : assert(
          ((isImage == false && schemaName.isNotEmpty) ||
              (isImage == true && schemaName.isEmpty)),
          "Don't allow both isImage and schemaName. If the image is, schemaName doesn't need. Just an empth string ! 🤩",
        );

  final bool isImage;
  final bool isForceRefresh;
  final bool allowPostMethod;
  final String schemaName;
  final Duration duration;
}

class ComputeExpired {
  ComputeExpired({
    required this.isar,
    required this.schemaName,
  });

  final Isar isar;
  final String schemaName;
}
