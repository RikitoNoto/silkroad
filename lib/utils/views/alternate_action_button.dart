import 'package:flutter/material.dart';
import 'package:animate_icons/animate_icons.dart';

enum AlternateActionStatus{
  active,
  inactive,
}

typedef AlternateActionCallback = Function(AlternateActionStatus);

class AlternateActionButton extends StatefulWidget{
  const AlternateActionButton({
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
  AlternateActionButtonState createState() => AlternateActionButtonState();
}

class AlternateActionButtonState extends State<AlternateActionButton>{

  final AnimateIconController _controller = AnimateIconController();
  double? _progress = 0;

  @override
  Widget build(BuildContext context)
  {
    return InkWell(
      customBorder: const CircleBorder(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: _progress,
          ),
          AnimateIcons(
            startIcon: widget.startIcon,
            endIcon: widget.endIcon,
            onStartIconPress: _onStart,
            onEndIconPress: _onEnd,
            controller: _controller,
            duration: Duration(milliseconds: widget.durationMillis),
          ),
        ],
      ),
    );
  }

  bool _onStart()
  {
    _progress = null;
    if(widget.onTap != null){
      widget.onTap!(AlternateActionStatus.active);
    }
    setState((){

    });
    return true;
  }

  bool _onEnd()
  {
    _progress = 0;
    if(widget.onTap != null){
      widget.onTap!(AlternateActionStatus.inactive);
    }
    setState((){

    });
    return true;
  }

}
