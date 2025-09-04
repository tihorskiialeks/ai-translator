import 'dart:developer';

import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> paths;
  final List<Color> colors;

  const DrawingPainter({
    required this.paths,
    required this.colors,
    //
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < paths.length; i++) {
      log("i = $i");
      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round;
      for (int j = 0; j < paths[i].length - 1; j++) {
        log('J = $j; I = $i');
        canvas.drawLine(paths[i][j], paths[i][j + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
