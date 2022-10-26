import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:silkroad/option/params.dart';
import 'package:silkroad/option/option_manager.dart';

abstract class OptionInput extends StatelessWidget{
  const OptionInput({super.key});

  static void Function(String) _createCallbackForInput(Params param){
    return (value){
      OptionManager().set(param.toString(), value);
    };
  }

  static OptionInput construct(Params param, {Key? key}){
    Object? value = OptionManager().get(param.toString());
    switch(param){
      case Params.port: /// port number is input number param.
        return OptionNumberInput(label: param.label, key: key, onChanged: _createCallbackForInput(param), initialValue: value is String ? value : null,);
    }
  }
}

class OptionNumberInput extends OptionInput{
  const OptionNumberInput({
    required this.label,
    this.onChanged,
    this.initialValue,
    super.key,
  });

  final String label;
  final void Function(String)? onChanged;
  final String? initialValue;


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Card(
      borderOnForeground: false,
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
        child: Row(
          children: [
            SizedBox(
              width: screenSize.width * 0.3,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: initialValue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
