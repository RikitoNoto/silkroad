import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeInputField extends StatefulWidget {
  const ThemeInputField({
    super.key,
    this.labelText,
    this.contentPadding,
    this.textInputAction,
    this.onChanged,
    this.inputFormatters,
    this.keyboardType,
  });

  final String? labelText;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  @override
  State<ThemeInputField> createState() => _ThemeInputFieldState();
}

class _ThemeInputFieldState extends State<ThemeInputField> {

  bool _isFocus = false;

  @override
  Widget build(BuildContext context){
    return Focus(
      onFocusChange: (isFocus) {
        setState(() {
          _isFocus = isFocus;
        });
      },
      child: TextField(
        onChanged: widget.onChanged,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        cursorColor: _getFocusColor(context),
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: TextStyle(
            color: _isFocus ? _getFocusColor(context) : _getThemeBorderColor(context),
          ),
          contentPadding: widget.contentPadding,
          border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: _getFocusColor(context)!,
            )
          ),
        ),
        textInputAction: widget.textInputAction,
        maxLines: 1,
      ),
    );
  }

  Color? _getThemeBorderColor(BuildContext context){
    return Theme.of(context).primaryTextTheme.labelSmall?.decorationColor;
  }

  Color? _getFocusColor(BuildContext context){
    return Colors.blue;
  }

}
