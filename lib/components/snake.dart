import 'dart:async';

import 'package:flame/collisions.dart';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';

class Snake extends PositionComponent with CollisionCallbacks {
  late Paint paint;
  double speed = 300.0;
  late List<Vector2> body;
  late Vector2 direction;
  late SnakeGame gameRef;
  double snakeSize = 20;
  int snakeLength = 2;
  late RectangleHitbox hitbox;

  double updateTime = 0;
  Snake(this.gameRef);

  @override
  FutureOr<void> onLoad() {
    paint = Paint()..color = Colors.grey;
    body = [Vector2(0, 0)];
    direction = Vector2(snakeSize, 0);
    hitbox = RectangleHitbox(
      size: Vector2(snakeSize - 10, snakeSize - 10),
      isSolid: true,
    );
    add(hitbox);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    for (var segment in body) {
      canvas.drawRect(Rect.fromPoints(segment.toOffset(), segment.toOffset() + Vector2(20, 20).toOffset()), paint);
    }
  }

  @override
  void update(double dt) {
    if (updateTime < 0.1) {
      updateTime += dt;
      return;
    }
    updateTime = 0;

    final newHead = body.first + direction;
    hitbox.position = Vector2(newHead.x + 5, newHead.y + 5);
    body.insert(0, newHead);
    body.removeLast();

    if (newHead.x > gameRef.size.x) {
      newHead.x = 0;
    }
    if (newHead.x <= -snakeSize) {
      newHead.x = gameRef.size.x - snakeSize;
    }
    if (newHead.y > gameRef.size.y) {
      newHead.y = 0;
    }
    if (newHead.y <= -snakeSize) {
      final gameY = gameRef.size.y;
      final divide = gameY ~/ snakeSize.ceil();
      final finalSize = divide * snakeSize;
      newHead.y = finalSize - snakeSize;
    }

    // position.x += direction.x * speed / 100;
    // position.y += direction.y * speed / 100;

    // position.x = (position.x + gameRef.size.x) % gameRef.size.x;
    // position.y = (position.y + gameRef.size.y) % gameRef.size.y;

    // if (position.x < -20) {
    //   position.x = gameRef.size.x - 20;
    // }
    // if (position.y < 0) {
    //   position.y = gameRef.size.y;
    // }
  }

  void setDirection(Vector2 newDirection) {
    if (direction != -newDirection) {
      direction = newDirection;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    debugPrint('Collision detected');
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    debugPrint(intersectionPoints.toList().toString());
    debugPrint('onCollisionStart');
    snakeLength++;
    final newHead = body.first + direction;
    body.add(newHead);
  }
}
