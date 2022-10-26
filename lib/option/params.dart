
extension ParamLabel on Params{
  String get label {
    switch(this){
      case Params.port:
        return 'Port number';
    }
  }
}

enum Params{
  port,
}

