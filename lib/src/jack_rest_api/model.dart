import "package:dio/dio.dart";
import "package:jack_api/src/jack_rest_api/dio_methods.dart";
import "package:jack_api/src/util.dart";

class RestApiData {
  RestApiData({
    required this.dio,
    required this.methods,
    this.token,
  });

  final Dio dio;
  final JackApiMethods methods;

  String? token;
}

class OnlineStatus {
  factory OnlineStatus() {
    return I;
  }

  OnlineStatus._();

  static final OnlineStatus I = OnlineStatus._();

  bool? isOnline;
}

class BeforeCallBackConfig<T> extends CallBackModel {
  BeforeCallBackConfig({
    super.allowBoth,
    super.isAllowDefault,
    this.onCallBack,
  });

  CallBack<T>? onCallBack;
}

class AfterCallBackConfig<T, R> extends CallBackModel {
  AfterCallBackConfig({
    super.allowBoth,
    super.isAllowDefault,
    this.onCallBack,
  });

  AfterCallBack<T, R>? onCallBack;
}

class CallBackConfig extends CallBackModel {
  CallBackConfig({
    super.allowBoth,
    super.isAllowDefault,
    this.onCallBack,
  });

  CallBackNoArgs? onCallBack;
}

class CallBackModel {
  CallBackModel({
    this.allowBoth = false,
    this.isAllowDefault = true,
  });

  final bool isAllowDefault;
  final bool allowBoth;
}
