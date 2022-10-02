import 'package:flutter/material.dart';

class ThemeInputField extends StatefulWidget {
  const ThemeInputField({
    super.key,
    this.labelText,
    this.contentPadding,
  });

  final String? labelText;
  final EdgeInsetsGeometry? contentPadding;

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
