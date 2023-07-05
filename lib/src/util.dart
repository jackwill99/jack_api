import "package:flutter/foundation.dart";

void printError(String text) {
  debugPrint("\x1B[31m$text\x1B[0m");
}

typedef CallBackNoArgs = Future<void> Function();

typedef CallBackWithReturn = Future<bool> Function();

typedef CallBackFunc<T> = Future<void> Function(T data);

typedef CallBack<T> = Future<bool> Function(T data);

typedef AfterCallBack<T, R> = Future<bool> Function(T data, R result);

class BeforeCallBackConfig<T> {
  BeforeCallBackConfig({
    this.allowBoth = false,
    this.isAllowDefault = true,
    this.onCallBack,
  });
  bool isAllowDefault;
  bool allowBoth;
  CallBack<T>? onCallBack;
}

class AfterCallBackConfig<T, R> {
  AfterCallBackConfig({
    this.allowBoth = false,
    this.isAllowDefault = true,
    this.onCallBack,
  });
  bool isAllowDefault;
  bool allowBoth;
  AfterCallBack<T, R>? onCallBack;
}

class CallBackConfig {
  CallBackConfig({
    this.allowBoth = false,
    this.isAllowDefault = true,
    this.onCallBack,
  });
  bool isAllowDefault;
  bool allowBoth;
  CallBackNoArgs? onCallBack;
}
