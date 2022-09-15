import 'package:flutter/material.dart';
import 'dart:async';

class AnimatedPlayPauseButton extends StatefulWidget{
  const AnimatedPlayPauseButton({super.key});

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
    setState(() {
      if(_progress == null){
        _controller.reverse();
        _progress = 0;
      }else{
        _controller.forward();
        _progress = null;
      }
    });

  }

}
