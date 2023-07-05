import "package:jack_api/src/util.dart";

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
