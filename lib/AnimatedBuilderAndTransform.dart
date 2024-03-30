import 'dart:math' show pi;

import 'package:flutter/material.dart';

class AnimatedBuilderAndTransform extends StatefulWidget {
  const AnimatedBuilderAndTransform({super.key});

  @override
  State<AnimatedBuilderAndTransform> createState() =>
      _AnimatedBuilderAndTransformState();
}

class _AnimatedBuilderAndTransformState
    extends State<AnimatedBuilderAndTransform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(_animation.value),
              child: Container(
                height: 100,
                width: 100,
                color: Colors.blue,
              ),
            );
          },
        ),
      ),
    );
  }
}
