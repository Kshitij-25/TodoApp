import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/services.dart';

@immutable
class AppUtility {
  const AppUtility._();

  static hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
