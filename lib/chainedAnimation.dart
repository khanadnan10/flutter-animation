import 'dart:math' show pi;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum CircleSide {
  left,
  right,
}

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();
    late Offset offset;
    late bool clockWise;
    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockWise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockWise = true;
        break;
      default:
    }
    path.arcToPoint(
      offset,
      clockwise: clockWise,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
    );
    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  const HalfCircleClipper({
    required this.side,
  });

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class ChainedAnimationCurveClippers extends StatefulWidget {
  const ChainedAnimationCurveClippers({super.key});

  @override
  State<ChainedAnimationCurveClippers> createState() =>
      _ChainedAnimationCurveClippersState();
}

class _ChainedAnimationCurveClippersState
    extends State<ChainedAnimationCurveClippers> with TickerProviderStateMixin {
  late AnimationController _counterClockwiseController;
  late Animation<double> _counterClockAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _counterClockwiseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _counterClockAnimation = Tween<double>(
      begin: 0.0,
      end: -(pi / 2),
    ).animate(
      CurvedAnimation(
        parent: _counterClockwiseController,
        curve: Curves.bounceOut,
      ),
    );

    //flip controller
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: pi,
    ).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.bounceOut,
      ),
    );

    // counter clockwise listner
    _counterClockwiseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
          begin: _flipAnimation.value,
          end: _flipAnimation.value + pi,
        ).animate(
          CurvedAnimation(
            parent: _flipController,
            curve: Curves.bounceOut,
          ),
        );

        _flipController
          ..reset()
          ..forward();
      }
    });
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockAnimation = Tween<double>(
          begin: _counterClockAnimation.value,
          end: _counterClockAnimation.value + -(pi / 2),
        ).animate(
          CurvedAnimation(
            parent: _counterClockwiseController,
            curve: Curves.bounceOut,
          ),
        );

        _counterClockwiseController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    _counterClockwiseController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _counterClockwiseController
      ..reset()
      ..forward();
    const vh = 200.0;
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _counterClockwiseController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_counterClockAnimation.value),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AnimatedBuilder(
                        animation: _flipController,
                        builder: (context, ct) {
                          return Transform(
                            alignment: Alignment.centerRight,
                            transform: Matrix4.identity()
                              ..rotateY(_flipAnimation.value),
                            child: ClipPath(
                              clipper: const HalfCircleClipper(
                                  side: CircleSide.left),
                              child: Container(
                                height: vh,
                                width: vh,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }),
                  ),
                  Flexible(
                    child: AnimatedBuilder(
                        animation: _flipController,
                        builder: (context, ct) {
                          return Transform(
                            alignment: Alignment.centerLeft,
                            transform: Matrix4.identity()
                              ..rotateY(_flipAnimation.value),
                            child: ClipPath(
                              clipper: const HalfCircleClipper(
                                  side: CircleSide.right),
                              child: Container(
                                height: vh,
                                width: vh,
                                color: Colors.blue,
                              ),
                            ),
                          );
                        }),
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
