import 'package:flutter/material.dart';
import 'package:silkroad/utils/views/alternate_action_button.dart';

class PasswordActionField extends StatefulWidget{
  const PasswordActionField({
    required this.startIcon,
    required this.endIcon,
    this.onTap,
    this.durationMillis = 300,
    super.key
  });

  final IconData startIcon;
  final IconData endIcon;
  final AlternateActionCallback? onTap;
  final int durationMillis;


  @override
  PasswordActionFieldState createState() => PasswordActionFieldState();
}

class PasswordActionFieldState extends State<PasswordActionField>{

  bool _enableField = true;

  @override
  Widget build(BuildContext context)
  {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context)
  {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            // パスワード入力欄
            _buildPasswordField(),

            const SizedBox(
              width: 30,
            ),

            // ポート解放ボタン
            AlternateActionButton(
              startIcon: widget.startIcon,
              endIcon: widget.endIcon,
              onTap: _onTapActionButton,
              durationMillis: widget.durationMillis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField()
  {
    return Expanded(
      child: TextField(
        decoration: const InputDecoration(
          labelText: "Password",
        ),
        maxLines: 1,
        enabled: _enableField,
      ),
    );
  }

  void _onTapActionButton(AlternateActionStatus status)
  {
    setState(() {
      if(status == AlternateActionStatus.active){
        _enableField = false;
      }else{
        _enableField = true;
      }
    });

    if(widget.onTap != null){
      widget.onTap!(status);
    }
  }
}
