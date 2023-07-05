import "package:jack_api/jack_api.dart";

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

    // No(1) beforeValidate နှစ်ခုလုံးသုံးမယ်
    beforeValidate: BeforeCallBackConfig(
      allowBoth: true,
      // allowBoth ကို true ပေးလိုက်လို့ isAllowDefault ကို ဘာပေးပေး အသုံးမ၀င်ဘူး
      // allowBoth က first priority မို့
      isAllowDefault: false,
      // နှစ်ခုလုံးသုံးမှာမို့ callBack method declare လုပ်
      // data argument ဆိုတာ အပေါ်က onBeforeValidate က ပြန်ပေးထားတဲ့ value
      onCallBack: (data) async {
        return true;
      },
    ),

    // No(2) နှစ်ခုလုံး မသုံးဘူး
    afterValidate: AfterCallBackConfig(
      // allowBoth က default false ဖြစ်ပြီးသားမို့ မရေးတော့တာ
      //! တကယ်က allowBoth ကို false ပေးရမှာ။ နှစ်ခုလုံး မသုံးလို့

      // ပြီးရင် isAllowDefault ကို false ပေး ဘာလို့ဆို သူက default true ဖြစ်နေလို့
      isAllowDefault: false,

      //! နှစ်ခုလုံး မသုံးချင်ဘူးဆိုရင် ဒီအောက်က ရေးပြထားတဲ့ callBack method ကို လုံး၀ မရေးနဲ့ No(4) နဲ့ ညိသွားလိမ့်မယ်။ မသုံးချင်ရင် မရေးနဲ့
      // data argument က api request success ဖြစ်လို့ ပြန်ရတဲ့ data, result argument ဆိုတာ အပေါ်က onAfterValidate က ပြန်ပေးထားတဲ့ value
      onCallBack: (data, result) async {
        return true;
      },
    ),

    // No(3) default onTimeOutError ကိုပဲ သုံးမယ်။ ဒီ query မှာလည်း timeOutError အတွက် ထပ်ရေးစရာမရှိဘူး။ အဲ့တော့ default onTimeOutError ကိုပဲ သုံးမယ်ပေါ့
    timeOutError: CallBackConfig(
      //! ထုံးစံအတိုင်း နှစ်ခုလုံးသုံးမှာ မဟုတ်တဲ့အတွက် allowBoth က false ပေါ့။ ပြီးရင် default onTimeoutError method ကိုပဲသုံးမှာမို့ isAllowDefault ကို true ပေး။
      // ဒီမှာက default value တွေဖြစ်နေလို့ မရေးတော့တာ

      //! ဒီအခြေအနေမှာ onCallBack ရေးလည်း အသုံးမ၀င်ဘူး။ မသုံးချင် မ...?
      onCallBack: () async {},
    ),

    // No(4) ခုရေးမယ့် onCallBack method ပဲ အလုပ်လုပ်မယ်။ default method အလုပ်မလုပ်စေချင်ဘူး
    error: CallBackConfig(
      //! ထုံးစံအတိုင်း နှစ်ခုလုံးသုံးမှာ မဟုတ်တဲ့အတွက် allowBoth က false ပေါ့။ ပြီးရင် default method မသုံးတဲ့အတွက် သူ့ကို false ပေး
      isAllowDefault: false,

      // ပြီးရင် callBack method ရေး
      onCallBack: () async {},
    ),
  );
}
