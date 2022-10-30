
extension ParamLabel on Params{
  String get label {
    switch(this){
      case Params.name:
        return 'Name';
      case Params.port:
        return 'Port number';
    }
  }
}


extension ParamInputType on Params{
  InputType get inputType {
    switch(this){
      case Params.name:
        return InputType.text;
      case Params.port:
        return InputType.numberText;
    }
  }
}

enum InputType{
  text,
  numberText,
}

enum Params{
  name,
  port,
}

