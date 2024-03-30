import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'dart:math' show pi;

class ThreeDAnimation extends StatefulWidget {
  const ThreeDAnimation({super.key});

  @override
  State<ThreeDAnimation> createState() => _ThreeDAnimationState();
}

const vh = 150.0;

class _ThreeDAnimationState extends State<ThreeDAnimation>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late Tween<double> _animation;

  @override
  void initState() {
    super.initState();
    _xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    // animation
    _animation = Tween<double>(begin: 0, end: 2 * pi);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _xController,
            _yController,
            _zController,
          ]),
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateX(_animation.evaluate(_xController))
                ..rotateY(_animation.evaluate(_yController))
                ..rotateZ(_animation.evaluate(_zController)),
              child: Stack(
                children: [
                  // back box
                  Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        Vector3(0, 0, -vh),
                      ),
                    child: Container(
                      height: vh,
                      width: vh,
                      color: Colors.blue,
                    ),
                  ),
                  //top box
                  Container(
                    height: vh,
                    width: vh,
                    color: Colors.red,
                  ),
                  //back box
                  Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()..rotateY(pi / 2),
                    child: Container(
                      height: vh,
                      width: vh,
                      color: Colors.green,
                    ),
                  ),
                  Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()..rotateY(-pi / 2),
                    child: Container(
                      height: vh,
                      width: vh,
                      color: Colors.black,
                    ),
                  ),
                  Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()..rotateX(-pi / 2),
                    child: Container(
                      height: vh,
                      width: vh,
                      color: Colors.purple,
                    ),
                  ),
                  Transform(
                    alignment: Alignment.bottomCenter,
                    transform: Matrix4.identity()..rotateX(pi / 2),
                    child: Container(
                      height: vh,
                      width: vh,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
