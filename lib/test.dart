import "package:jack_api/jack_api.dart";
import "package:jack_api/src/jack_rest_api/model.dart";

void main() async {
  final api = JackRestApi(
    baseUrl: "baseUrl",
    onBeforeValidate: () async {
      return true;
    },
    onAfterValidate: (data) async {
      // TODO(jackwill): use type cast
      return true;
    },
    onTimeOutError: () async {
      // connection time out
    },
    onError: () async {
      // 404, 500, 503, 400
    },
  );

  void setTokenToDefault() {
    api.myToken = "";
  }

  await api.query<String>(
    method: "GET",
    path: "path",
    onSuccess: (data) async {},

    // this will work both before methods
    beforeValidate: BeforeCallBackConfig(
      allowBoth: true,
      // this will not affect on the allowing of default method
      isAllowDefault: false,
      onCallBack: (data) async {
        return true;
      },
    ),

    // this will not work both after methods
    afterValidate: AfterCallBackConfig(
      isAllowDefault: false,
      //! If you want to not work both after methods.
      //! Don't make methods. This will be cause to allow only callBack method
      onCallBack: (data, result) async {
        return true;
      },
    ),

    // this will use only default timeout method
    timeOutError: CallBackConfig(
      //! will not work
      onCallBack: () async {},
    ),

    // this will use only callback error method
    error: CallBackConfig(
      isAllowDefault: false,
      onCallBack: () async {},
    ),
  );
}
