class JackApiCacheOptions {
  JackApiCacheOptions({
    required this.schemaName,
    this.allowPostMethod = false,
    this.isForceRefresh = false,
    this.duration = const Duration(minutes: 3),
  });

  final bool isForceRefresh;
  final bool allowPostMethod;
  final String schemaName;
  final Duration duration;
}

class CacheOptionsStatus {
  CacheOptionsStatus({
    required this.cacheEnable,
    required this.schemaName,
    this.allowPostMethod = false,
    this.isForceRefresh = false,
    this.duration = const Duration(minutes: 3),
  });

  factory CacheOptionsStatus.fromMap(Map<String, dynamic> map) {
    return CacheOptionsStatus(
      cacheEnable: map["cacheEnable"] as bool,
      isForceRefresh: map["isForceRefresh"] as bool,
      allowPostMethod: map["allowPostMethod"] as bool,
      schemaName: map["schemaName"] as String,
      duration: map["duration"] as Duration,
    );
  }

  final bool cacheEnable;
  final bool isForceRefresh;
  final bool allowPostMethod;
  final String schemaName;
  final Duration duration;

  Map<String, dynamic> toMap() {
    return {
      "cacheEnable": cacheEnable,
      "isForceRefresh": isForceRefresh,
      "allowPostMethod": allowPostMethod,
      "schemaName": schemaName,
      "duration": duration,
    };
  }
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
