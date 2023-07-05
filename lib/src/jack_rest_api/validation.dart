import "package:jack_api/src/jack_rest_api/model.dart";
import "package:jack_api/src/util.dart";

Future<bool> checkBeforeValidate({
  required BeforeCallBackConfig<bool?> beforeValidate,
  CallBackWithReturn? oldBeforeValidate,
}) async {
  if (beforeValidate.allowBoth) {
    if (oldBeforeValidate != null) {
      final before = await oldBeforeValidate();

      if (beforeValidate.onCallBack != null) {
        printError("You allow both methods and now calling these ...");
        final beforeTransfer = await beforeValidate.onCallBack!(before);
        if (!beforeTransfer) {
          printError("Failed to pass ... ⬆️ ⬆️ ⬆️");
        }
        return beforeTransfer;
      } else {
        printError(
          "You allow both methods to call but you have no call back method 🥹",
        );
        if (!before) {
          printError("Failed to pass ... ⬆️ ⬆️ ⬆️");
        }
        return before;
      }
    } else if (beforeValidate.onCallBack != null) {
      printError(
        "You allow both methods to call but you have no default before method,",
      );
      final before = await beforeValidate.onCallBack!(null);
      if (!before) {
        printError("Failed to pass ... ⬆️ ⬆️ ⬆️");
      }
      return before;
    } else {
      printError(
        "You allow both methods to call but you have no both methods. What the fuck bro ... 🖕",
      );
      return true;
    }
  } else if (!beforeValidate.allowBoth && beforeValidate.isAllowDefault) {
    if (oldBeforeValidate != null) {
      printError(
        "You allow only default before method and calling this method ...",
      );
      final before = await oldBeforeValidate();
      if (!before) {
        printError("Failed to pass ... ⬆️ ⬆️ ⬆️");
      }
      return before;
    } else {
      printError(
        "You allow only default before method but you have no default method",
      );
      return true;
    }
  } else if (!beforeValidate.allowBoth && !beforeValidate.isAllowDefault) {
    if (beforeValidate.onCallBack != null) {
      printError(
        "Overriding the default before validate method and calling this method ...",
      );
      final before = await beforeValidate.onCallBack!(null);
      if (!before) {
        printError("Failed to pass ... ⬆️ ⬆️ ⬆️");
      }
      return before;
    } else {
      printError(
        "You are not using both before method. ❌",
      );
      return true;
    }
  }
  printError("No one match in before method ... ⬆️ ⬆️ ⬆️");
  return true;
}

Future<bool> checkAfterValidate<T>({
  required T data,
  required AfterCallBackConfig<T, bool?> afterValidate,
  CallBack<T>? oldAfterValidate,
}) async {
  if (afterValidate.allowBoth) {
    if (oldAfterValidate != null) {
      final before = await oldAfterValidate(data);

      if (afterValidate.onCallBack != null) {
        printError("You allow both methods and now calling these ...");
        final beforeTransfer = await afterValidate.onCallBack!(data, before);
        if (!beforeTransfer) {
          printError("Failed to pass ... ⬆️ ⬆️ ⬆️");
        }
        return beforeTransfer;
      } else {
        printError(
          "You allow both methods to call but you have no call back method 🥹",
        );
        if (!before) {
          printError("Failed to pass ... ⬆️ ⬆️ ⬆️");
        }
        return before;
      }
    } else if (afterValidate.onCallBack != null) {
      printError(
        "You allow both methods to call but you have no default after method,",
      );
      final before = await afterValidate.onCallBack!(data, null);
      if (!before) {
        printError("Failed to pass ... ⬆️ ⬆️ ⬆️");
      }
      return before;
    } else {
      printError(
        "You allow both methods to call but you have no both methods. What the fuck bro ... 🖕",
      );
      return true;
    }
  } else if (!afterValidate.allowBoth && afterValidate.isAllowDefault) {
    if (oldAfterValidate != null) {
      printError(
        "You allow only default after method and calling this method ...",
      );
      final before = await oldAfterValidate(data);
      if (!before) {
        printError("Failed to pass ... ⬆️ ⬆️ ⬆️");
      }
      return before;
    } else {
      printError(
        "You allow only default after method but you have no default method",
      );
      return true;
    }
  } else if (!afterValidate.allowBoth && !afterValidate.isAllowDefault) {
    if (afterValidate.onCallBack != null) {
      printError(
        "Overriding the default after validate method and calling this method ...",
      );
      final before = await afterValidate.onCallBack!(data, null);
      if (!before) {
        printError("Failed to pass ... ⬆️ ⬆️ ⬆️");
      }
      return before;
    } else {
      printError(
        "You are not using both after method. ❌",
      );
      return true;
    }
  }
  printError("No one match in after method ... ⬆️ ⬆️ ⬆️");
  return true;
}

Future<void> checkTimeOut({
  required CallBackConfig timeOutError,
  CallBackNoArgs? oldTimeOutError,
}) async {
  if (timeOutError.allowBoth) {
    if (oldTimeOutError != null) {
      await oldTimeOutError();

      if (timeOutError.onCallBack != null) {
        printError("You allow both methods and now calling these ...");
        await timeOutError.onCallBack!();
      } else {
        printError(
          "You allow both methods to call but you have no call back method 🥹",
        );
      }
    } else if (timeOutError.onCallBack != null) {
      printError(
        "You allow both methods to call but you have no default timeout method,",
      );
      await timeOutError.onCallBack!();
    } else {
      printError(
        "You allow both methods to call but you have no both methods. What the fuck bro ... 🖕",
      );
    }
  } else if (!timeOutError.allowBoth && timeOutError.isAllowDefault) {
    if (oldTimeOutError != null) {
      printError(
        "You allow only default timeout method and calling this method ...",
      );
      await oldTimeOutError();
    } else {
      printError(
        "You allow only default timeout method but you have no default method",
      );
    }
  } else if (!timeOutError.allowBoth && !timeOutError.isAllowDefault) {
    if (timeOutError.onCallBack != null) {
      printError(
        "Overriding the default timeout  method and calling this method ...",
      );
      await timeOutError.onCallBack!();
    } else {
      printError(
        "You are not using both timeout method. ❌",
      );
    }
  }
  printError("No one match in timeout method ... ⬆️ ⬆️ ⬆️");
}

Future<void> checkError({
  required CallBackConfig error,
  CallBackNoArgs? oldError,
}) async {
  if (error.allowBoth) {
    if (oldError != null) {
      await oldError();

      if (error.onCallBack != null) {
        printError("You allow both methods and now calling these ...");
        await error.onCallBack!();
      } else {
        printError(
          "You allow both methods to call but you have no call back method 🥹",
        );
      }
    } else if (error.onCallBack != null) {
      printError(
        "You allow both methods to call but you have no default error method,",
      );
      await error.onCallBack!();
    } else {
      printError(
        "You allow both methods to call but you have no both methods. What the fuck bro ... 🖕",
      );
    }
  } else if (!error.allowBoth && error.isAllowDefault) {
    if (oldError != null) {
      printError(
        "You allow only default error method and calling this method ...",
      );
      await oldError();
    } else {
      printError(
        "You allow only default error method but you have no default method",
      );
    }
  } else if (!error.allowBoth && !error.isAllowDefault) {
    if (error.onCallBack != null) {
      printError(
        "Overriding the default error method and calling this method ...",
      );
      await error.onCallBack!();
    } else {
      printError(
        "You are not using both error method. ❌",
      );
    }
  }
  printError("No one match in error method ... ⬆️ ⬆️ ⬆️");
}
