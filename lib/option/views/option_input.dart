import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:silkroad/option/params.dart';
import 'package:silkroad/option/option_manager.dart';

abstract class OptionInput extends StatelessWidget{
  const OptionInput({super.key});

  static void Function(String) createCallbackForInput(Params param){
    return (value){
      OptionManager().set(param.toString(), value);
    };
  }

  static OptionInput construct(Params param, {Key? key}){
    Object? value = OptionManager().get(param.toString());

    switch(param.inputType){
      case InputType.numberText:
        return OptionNumberInput(label: param.label, key: key, onChanged: createCallbackForInput(param), initialValue: value is String ? value : null,);
      case InputType.text:
        return OptionInputText(label: param.label, key: key, onChanged: createCallbackForInput(param), initialValue: value is String ? value : null,);
    }
  }
}

abstract class OptionInputBase extends OptionInput{
  const OptionInputBase({super.key});

  Widget constructInputField(BuildContext context, {
    required String label,
    void Function(String)? onChanged,
    String? initialValue,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,}
  ) {
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
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                inputFormatters: inputFormatters,
                keyboardType: keyboardType,
                controller: TextEditingController(text: initialValue),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class OptionInputText extends OptionInputBase{
  const OptionInputText({
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
    return super.constructInputField(context, label: label, onChanged: onChanged, initialValue: initialValue);
  }
}

class OptionNumberInput extends OptionInputBase{
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
    return super.constructInputField(
      context,
      label: label,
      onChanged: onChanged,
      initialValue: initialValue,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,

    );
  }
}
