import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';

class Food extends PositionComponent {
  late Paint paint;
  late SnakeGame gameRef;
  final random = Random();

  Food(this.gameRef);

  void randomizePosition() {
    final canvasSize = gameRef.canvasSize.toSize();
    final canvasX = canvasSize.width / 2;
    final canvasY = canvasSize.height / 2;
    position.x = (random.nextDouble() * canvasX);
    position.y = (random.nextDouble() * canvasY);
    x = 60;
    y = 60;
  }

  @override
  FutureOr<void> onLoad() {
    randomizePosition();
    paint = Paint()..color = const Color(0xFFFF0000).withOpacity(0.5);
    add(RectangleHitbox(isSolid: true, position: position, size: Vector2(20, 20)));

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromPoints(Offset(position.x, position.y), Offset(position.x + 20, position.y + 20)), paint);
  }
}
