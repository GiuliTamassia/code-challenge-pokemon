import 'package:flutter/material.dart';
import 'dart:math';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: RotatingPokeballMenu(),
        ),
      ),
    );
  }
}

class RotatingPokeballMenu extends StatefulWidget {
  final void Function()? onTap;
  final bool rotateRight;

  const RotatingPokeballMenu({super.key, this.onTap, this.rotateRight = true});

  @override
  RotatingPokeballMenuState createState() => RotatingPokeballMenuState();
}

class RotatingPokeballMenuState extends State<RotatingPokeballMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _rotateBall() {
    if (!_controller.isAnimating) {
      _controller.forward().whenComplete(() {
        widget.onTap?.call();
        _controller.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final menuSize = min(screenSize.width, screenSize.height) * 0.14;
    return GestureDetector(
      onTap: _rotateBall,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          double rotation = _animation.value * 3.14159; // 180 Grad
          if (widget.rotateRight) {
            rotation += 3.14159;
          }
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              Positioned(
                right: menuSize / 3,
                bottom: menuSize / 3,
                child: Transform(
                  alignment: Alignment.center,
                  transform: widget.rotateRight
                      ? Matrix4.rotationZ(rotation)
                      : Matrix4.rotationZ(-rotation),
                  child: CustomPaint(
                    painter: PokeballPainter(),
                    size: Size(menuSize, menuSize),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PokeballPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 1.8,
      shadowPaint,
    );

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    Paint circlePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        size.width / 1.98, circlePaint);

    Path upperHalf = Path()
      ..moveTo(0, size.height / 2)
      ..arcToPoint(Offset(size.width, size.height / 2),
          radius: Radius.circular(size.width / 2), clockwise: true)
      ..close();
    canvas.drawPath(upperHalf, paint);

    paint.color = Colors.red;
    Path lowerHalf = Path()
      ..moveTo(0, size.height / 2)
      ..arcToPoint(Offset(size.width, size.height / 2),
          radius: Radius.circular(size.width / 2), clockwise: false)
      ..close();
    canvas.drawPath(lowerHalf, paint);

    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 6, circlePaint);
    circlePaint.color = Colors.white;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 9, circlePaint);
    circlePaint.color = Colors.grey;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 18, circlePaint);
    circlePaint.color = Colors.white;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 20, circlePaint);

    Paint bigpen = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;

    Path blackPart = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width - size.width / 2 - size.width / 8, size.height / 2);
    canvas.drawPath(blackPart, bigpen);

    Path blackPart2 = Path()
      ..moveTo(size.height / 2 + size.width / 8, size.height / 2)
      ..lineTo(size.width, size.height / 2);
    canvas.drawPath(blackPart2, bigpen);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
