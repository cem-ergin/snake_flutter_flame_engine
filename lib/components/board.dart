import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/main.dart';

class Board extends PositionComponent {
  final Vector2 boardSize;
  late Paint gray;
  late Paint lightGray;

  Board({super.children, super.priority, super.key, required this.boardSize});

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    gray = Paint()..color = Colors.grey.withOpacity(.1);
    lightGray = Paint()..color = Colors.grey[300]!.withOpacity(.1);
  }

  @override
  void render(Canvas canvas) {
    for (int i = 0; i < (boardSize.x / snakeSize).floorToDouble(); i++) {
      for (int j = 0; j < (boardSize.y / snakeSize).floorToDouble(); j++) {
        final rect = Rect.fromLTWH(i * snakeSize, j * snakeSize, snakeSize, snakeSize);
        canvas.drawRect(rect, (i + j) % 2 == 0 ? gray : lightGray);
      }
    }
  }
}
