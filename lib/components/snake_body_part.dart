import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/main.dart';

class SnakeBodyPart extends PositionComponent with HasCollisionDetection {
  late Paint paint;
  late RectangleHitbox hitbox;

  SnakeBodyPart(Vector2 position) {
    this.position = position;
    size = Vector2(snakeSize, snakeSize);

    hitbox = RectangleHitbox(
      size: Vector2(snakeSize - 10, snakeSize - 10),
      isSolid: true,
    );
    add(hitbox);
  }

  @override
  FutureOr<void> onLoad() {
    paint = Paint()..color = Colors.blue;
    return super.onLoad();
  }
}
