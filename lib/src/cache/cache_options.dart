// ignore_for_file: public_member_api_docs, sort_constructors_first

class JackApiCacheOptions {
  JackApiCacheOptions({
    required this.schemaName,
    this.allowPostMethod = false,
    this.isImage = false,
    this.isForceRefresh = false,
    this.duration = const Duration(minutes: 3),
  }) : assert(
          ((isImage == false && schemaName.isNotEmpty) ||
              (isImage == true && schemaName.isEmpty)),
          "Don't allow both isImage and schemaName. If the image is, schemaName doesn't need. Just an empty string ! 🤩",
        );

  final bool isImage;
  final bool isForceRefresh;
  final bool allowPostMethod;
  final String schemaName;
  final Duration duration;
}

/// [key] must be unique
class DataCacheOptions {
  DataCacheOptions({
    required this.data,
    required this.expiry,
    required this.key,
    required this.schemaName,
  });

  final String schemaName;
  final String key;
  final String data;
  final Duration expiry;
}



// class ComputeExpired {
//   ComputeExpired({
//     required this.isar,
//     required this.schemaName,
//   });
//
//   final Isar isar;
//   final String schemaName;
// }
