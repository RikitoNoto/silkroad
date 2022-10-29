
extension ParamLabel on Params{
  String get label {
    switch(this){
      case Params.port:
        return 'Port number';
    }
  }
}


extension ParamInputType on Params{
  InputType get inputType {
    switch(this){
      case Params.port:
        return InputType.numberText;
    }
  }
}

enum InputType{
  numberText,
}

enum Params{
  port,
}

