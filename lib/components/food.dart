import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';
import 'package:snake_flame_engine_flutter/main.dart';

class Food extends PositionComponent {
  late Paint paint;
  late SnakeGame gameRef;
  late RectangleHitbox hitbox;
  final random = Random();

  Food(this.gameRef);

  void randomizePosition(List<Vector2> occupiedPositions) {
    print('randomizePosition');
    final canvasSize = gameRef.canvasSize.toSize();
    final canvasX = canvasSize.width / 2;
    final canvasY = canvasSize.height / 2;
    final randomPosition = Vector2(
      (random.nextDouble() * canvasX / 20).floor() * 20,
      (random.nextDouble() * canvasY / 20).floor() * 20,
    );
    if (occupiedPositions.isNotEmpty) {
      for (var pos in occupiedPositions) {
        if (pos.x == randomPosition.x && pos.y == randomPosition.y) {
          randomizePosition(occupiedPositions);
          return;
        }
      }
    }
    position = randomPosition;
    hitbox.x = randomPosition.x;
    hitbox.y = randomPosition.y;
  }

  @override
  FutureOr<void> onLoad() {
    hitbox = RectangleHitbox(isSolid: true, position: Vector2(180, 120), size: Vector2(20, 20));
    add(hitbox);
    paint = Paint()..color = const Color(0xFFFF0000).withOpacity(0.5);

    randomizePosition([]);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromPoints(position.toOffset(), position.toOffset() + Vector2(snakeSize, snakeSize).toOffset()),
      paint,
    );
  }
}
