import 'package:flutter/material.dart';
import 'dart:math' as math;

class Board {
  int _width = 0, _height = 0, _count = 0;
  math.Random _rand = math.Random();
  List<int> _grid = [];
  List<bool> _selected = [];
  double _scale = 1;

  int _randCellIndex() {
    return _rand.nextInt(_count) + 1;
  }

  int xyToGridIndex(int x, int y) {
    assert(x >= 0 && x < _width);
    assert(y >= 0 && y < _height);
    return (y + 1) * (_width + 2) + x + 1;
  }

  Board(int w, int h, int count) {
    _width = w;
    _height = h;
    _count = count;
    final gridCount = (w + 2) * (h + 2);
    _grid = List<int>.filled(gridCount, 0);
    _selected = List<bool>.filled(gridCount, false);

    for (int y = 0; y < h; ++y) {
      for (int x = 0; x < w; ++x) {
        final index = xyToGridIndex(x, y);
        _grid[index] = _randCellIndex();
      }
    }
  }

  void clearSelected() {
    _selected.fillRange(0, _selected.length, false);
  }

  void setSize(Size size) {
    _scale = math.min(size.width, size.height) / _width;
  }

  int get width => _width;

  final double _radius = 0.30;
  final _dotPaint = Paint();

  final _colors = [
    0, // not a dot
    0xFFFF0000, 0xFF00CC00, 0xFF0000FF,
    0xFFFF00FF, 0xFF00CCFF,
  ];

  int xyToCell(int x, int y) {
    return _grid[xyToGridIndex(x, y)];
  }

  void drawDot(Canvas canvas, int x, int y) {
    int index = xyToGridIndex(x, y);
    int cell = _grid[index];
    assert(cell > 0);
    final color = Color(_colors[cell]);

    if (_selected[index]) {
      _dotPaint.color = color.withOpacity(0.25);
      canvas.drawRect(
          Rect.fromLTWH(x.toDouble(), y.toDouble(), 1, 1), _dotPaint);
    }
    _dotPaint.color = color;
    canvas.drawCircle(Offset(x + 0.5, y + 0.5), _radius, _dotPaint);
  }

  void paint(Canvas canvas) {
    canvas.save();
    canvas.scale(_scale);
    for (int y = 0; y < _height; ++y) {
      for (int x = 0; x < _width; ++x) {
        drawDot(canvas, x, y);
      }
    }
    canvas.restore();
  }

  int pointerToIndex(double x, double y) {
    final ix = (x / _scale).floor().clamp(0, _width - 1);
    final iy = (y / _scale).floor().clamp(0, _height - 1);
    return xyToGridIndex(ix, iy);
  }

  void pointerDown(double x, double y) {
    final index = pointerToIndex(x, y);
//    print('setting $index to true from $x $y');
    _selected[index] = true;
  }

  void pointerMove(double x, double y) {
    pointerDown(x, y);
  }

  void pointerUp(double x, double y) {
    clearSelected();
  }
}
