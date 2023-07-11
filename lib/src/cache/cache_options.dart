class JackApiCacheOptions {
  JackApiCacheOptions({
    required this.schemaName,
    this.allowPostMethod = false,
    this.isImage = false,
    this.isForceRefresh = false,
    this.duration = const Duration(hours: 2),
  })  : assert(
          (isImage == true && schemaName.isNotEmpty),
          "Don't allow both isImage and schemaName. If the image is, schemaName doesn't need. Just an empth string ! 🤩",
        ),
        assert(
          (isImage == false && schemaName.isEmpty),
          "When you don't use for image, declare the schemaName",
        );

  final bool isImage;
  final bool isForceRefresh;
  final bool allowPostMethod;
  final String schemaName;
  final Duration duration;
}
