import "package:flutter/foundation.dart";

void printError(String text) {
  debugPrint("\x1B[31m$text\x1B[0m");
}

typedef CallBackFunc<T> = Future<void> Function(T data);
typedef CallBackFuncSync<T> = void Function(T data);

typedef AfterCallBack<T> = Future<bool> Function(T data);
typedef AfterCallBackSync<T> = bool Function(T data);
