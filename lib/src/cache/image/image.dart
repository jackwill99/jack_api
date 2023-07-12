import "dart:typed_data";
import "dart:ui";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:jack_api/jack_api.dart";

/// Basic image downloader
/// Production implementation should use stream instead
/// to avoid OOM problems & improve performance
class JackCacheImage extends ImageProvider<JackCacheImage> {
  const JackCacheImage({
    required this.url,
    this.duration = const Duration(days: 5),
  });

  final String url;
  final Duration duration;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is JackCacheImage && other.url == url;
  }

  @override
  int get hashCode => url.hashCode ^ RestApiData.dio.hashCode;

  @override
  ImageStreamCompleter loadImage(
    JackCacheImage key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      // ignore: discarded_futures
      codec: _loadAsync(decode),
      scale: 1.0,
    );
  }

  @override
  Future<JackCacheImage> obtainKey(ImageConfiguration configuration) {
    // Force eviction of previously cached image by flutter framework
    // Without this line, load(...) isn't called again
    // This is only for testing purpose
    PaintingBinding.instance.imageCache.evict(this);

    return Future.value(this);
  }

  @override
  String toString() => "$JackCacheImage $url";

  Future<Codec> _loadAsync(ImageDecoderCallback decode) async {
    final response = await RestApiData.dio.get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        extra: {
          "enableCache": true,
          "isImage": true,
          "schemaName": "",
          "duration": duration,
        },
      ),
    );

    late Uint8List? bytes;

    if (response.data != null && response.data is Uint8List) {
      bytes = response.data as Uint8List;
    } else {
      /// List<dynamic> comes from cache
      bytes = _changeImageBinary(response.data);
    }

    if (bytes.isEmpty) {
      throw StateError("$url cannot be loaded as an image.");
    }
    final immutalbeBuffer = await ImmutableBuffer.fromUint8List(bytes);
    debugPrint(
      "----------------------${response.statusCode}----------------------",
    );

    return decode(immutalbeBuffer);
  }

  /// change cache image list dynamic to uint8List
  Uint8List _changeImageBinary(List<dynamic> dynamicList) {
    final List<int> intList =
        dynamicList.cast<int>().toList(); //This is the magical line.
    final data = Uint8List.fromList(intList);
    return data;
  }
}
