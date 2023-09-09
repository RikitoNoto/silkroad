import 'package:silkroad/i18n/translations.g.dart';

extension ParamLabel on Params {
  String get label {
    switch (this) {
      case Params.name:
        return t.params.name;
      case Params.port:
        return t.params.port;
      default:
        return "";
    }
  }
}

extension ParamInputType on Params {
  InputType get inputType {
    switch (this) {
      case Params.name:
        return InputType.text;
      case Params.port:
        return InputType.numberText;
      default:
        return InputType.none;
    }
  }
}

enum InputType {
  none,
  text,
  numberText,
}

enum Params {
  name,
  port,
  isShowTutorialSend,
  isShowTutorialReceive,
}

const userInputParams = [
  Params.name,
  Params.port,
];
