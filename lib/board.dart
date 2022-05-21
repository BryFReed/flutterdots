import 'package:flutter/material.dart';
import 'dart:math' as math;

class Board {
  int _width = 0, _height = 0, _count = 0;
  math.Random _rand = math.Random();
  List<int> _grid = [];

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
    _grid = List<int>.filled((w + 2) * (h + 2), 0);

    for (int y = 0; y < h; ++y) {
      for (int x = 0; x < w; ++x) {
        final index = xyToGridIndex(x, y);
        _grid[index] = _randCellIndex();
      }
    }
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
    int cell = xyToCell(x, y);
    assert(cell > 0);
    _dotPaint.color = Color(_colors[cell]);
    canvas.drawCircle(Offset(x + 0.5, y + 0.5), _radius, _dotPaint);
  }

  void paint(Canvas canvas) {
    for (int y = 0; y < _height; ++y) {
      for (int x = 0; x < _width; ++x) {
        drawDot(canvas, x, y);
      }
    }
  }
}
