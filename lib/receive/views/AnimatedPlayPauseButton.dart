import 'package:flutter/material.dart';

class AnimatedPlayPauseButton extends StatefulWidget{
  const AnimatedPlayPauseButton({super.key});

  @override
  _AnimatedPlayPauseButtonState createState() => _AnimatedPlayPauseButtonState();
}

class _AnimatedPlayPauseButtonState extends State<AnimatedPlayPauseButton>
      with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  double? _progress;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  void setProgress(double? progress)
  {
    setState(() {
      _progress = progress;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Stack(
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
    )
  }
}
