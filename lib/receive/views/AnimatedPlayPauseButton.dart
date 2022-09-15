import 'package:flutter/material.dart';
import 'dart:async';

enum AnimatedPlayPause{
  play,
  pause,
}

typedef AnimatedPlayPauseCallback = Function(AnimatedPlayPause);

class AnimatedPlayPauseButton extends StatefulWidget{
  const AnimatedPlayPauseButton({
    this.onTap,
    super.key
  });
  final AnimatedPlayPauseCallback? onTap;

  @override
  _AnimatedPlayPauseButtonState createState() => _AnimatedPlayPauseButtonState();
}

class _AnimatedPlayPauseButtonState extends State<AnimatedPlayPauseButton>
      with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  double? _progress = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: _onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: _progress,
          ),
          AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: _controller,
          ),
        ],
      ),
    );
  }

  void _onPressed ()
  {
    AnimatedPlayPause currentState = AnimatedPlayPause.pause;
    setState(() {
      if(_progress == null){
        _controller.reverse();
        _progress = 0;
        currentState = AnimatedPlayPause.pause;
      }else{
        _controller.forward();
        _progress = null;
        currentState = AnimatedPlayPause.play;
      }
    });

    if(widget.onTap != null){
      widget.onTap!(currentState);
    }

  }

}
