import 'package:flutter/material.dart';
import 'board.dart';
import 'dart:math' as math;

//import 'package:flutter/widgets.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  double x = 0.0;
  double y = 0.0;
  Board _board = Board(6, 6, 5);

  void _incrementDown(PointerEvent details) {
    _updateLocation(details);
  }

  void _incrementUp(PointerEvent details) {
    _updateLocation(details);
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Listener(
        onPointerDown: _incrementDown,
        onPointerMove: _updateLocation,
        onPointerUp: _incrementUp,
        child: CustomPaint(
          size: Size.infinite,
          painter: MyPainter(_board),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  MyPainter(Board b) : _board = b;

  final Board _board;

  @override
  void paint(Canvas canvas, Size size) {
    double n = math.min(size.width, size.height) / _board.width;
    canvas.save();
    canvas.scale(n, n);
    _board.paint(canvas);
    canvas.restore();
//    canvas.drawColor(const Color(0xFFFF0000), BlendMode.srcOver);
  }

  //Called when CustomPainter is rebuilt.
  //Returning true because we want canvas to be rebuilt to reflect new changes.
  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
}
