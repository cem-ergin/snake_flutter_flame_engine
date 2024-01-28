import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';
import 'package:snake_flame_engine_flutter/main.dart';

class Board extends PositionComponent {
  final Vector2 boardSize;
  late Paint white;
  late Paint red;
  final SnakeGame gameRef;

  Board(this.gameRef, {super.children, super.priority, super.key, required this.boardSize});

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    position = gameRef.size / 2 - boardSize;
    white = Paint()..color = Colors.white.withOpacity(.8);
    red = Paint()..color = Colors.red.withOpacity(.8);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = size / 2 - boardSize;
  }

  @override
  void render(Canvas canvas) {
    for (int i = 0; i < (boardSize.x / snakeSize).floorToDouble(); i++) {
      for (int j = 0; j < (boardSize.y / snakeSize).floorToDouble(); j++) {
        final rect = Rect.fromLTWH(i * snakeSize, j * snakeSize, snakeSize, snakeSize);
        canvas.drawRect(rect, (i + j) % 2 == 0 ? red : white);
      }
    }
  }
}
