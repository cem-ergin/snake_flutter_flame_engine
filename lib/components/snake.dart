import 'dart:async';

import 'package:flame/collisions.dart';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/components/food.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';

class Snake extends PositionComponent with CollisionCallbacks {
  late Paint headPaint;
  late Paint bodyPaint;
  double speed = 300.0;
  late Vector2 head;
  late Vector2 direction;
  late SnakeGame gameRef;
  double snakeSize = 20;
  late RectangleHitbox hitbox;
  double updateTime = 0;
  late List<SnakeBody> snakeBody;
  bool addNewBody = false;

  Snake(this.gameRef);

  @override
  FutureOr<void> onLoad() {
    headPaint = Paint()..color = Colors.orange;
    bodyPaint = Paint()..color = Colors.grey;
    head = Vector2(0, 0);
    direction = Vector2(snakeSize, 0);
    hitbox = RectangleHitbox(
      position: Vector2(head.x + 5, head.y + 5),
      size: Vector2(snakeSize - 10, snakeSize - 10),
      isSolid: true,
    );
    add(hitbox);

    snakeBody = [];
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromPoints(head.toOffset(), head.toOffset() + Vector2(snakeSize, snakeSize).toOffset()),
      headPaint,
    );

    for (var body in snakeBody) {
      canvas.drawRect(
        Rect.fromPoints(body.position.toOffset(), body.position.toOffset() + Vector2(snakeSize, snakeSize).toOffset()),
        bodyPaint,
      );
    }
  }

  @override
  void update(double dt) {
    if (updateTime < 0.3) {
      updateTime += dt;
      return;
    }
    updateTime = 0;

    if (addNewBody) {
      addBody();
      addNewBody = false;
    } else {
      move();
    }
    handleOffDimensions(head);
    moveHitbox();
  }

  void moveHitbox() {
    hitbox.x = head.x + 5;
    hitbox.y = head.y + 5;
  }

  void move({bool isBodyAdded = false}) {
    final oldHead = head;
    final newHead = head + direction;
    head = newHead;
    hitbox.position = Vector2(head.x + 5, head.y + 5);

    if (!isBodyAdded) {
      moveBody(oldHead);
    }
  }

  void moveBody(Vector2 oldHead) {
    if (snakeBody.isEmpty) {
      return;
    }
    for (var i = snakeBody.length - 1; i >= 0; i--) {
      if (i == 0) {
        snakeBody[i].position = oldHead;
      } else {
        snakeBody[i].position = snakeBody[i - 1].position;
      }
    }
  }

  void addBody() {
    final oldHead = head;
    final newBody = SnakeBody(oldHead);
    snakeBody.insert(0, newBody);
    add(newBody);
    move(isBodyAdded: true);
  }

  void handleOffDimensions(Vector2 newHead) {
    if (newHead.x > gameRef.size.x) {
      newHead.x = 0;
    }
    if (newHead.x <= -snakeSize) {
      newHead.x = gameRef.size.x - snakeSize;
      final gameX = gameRef.size.x;
      final divide = gameX ~/ snakeSize.ceil();
      final finalSize = divide * snakeSize;
      newHead.x = finalSize - snakeSize;
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
  }

  void setDirection(Vector2 newDirection) {
    if (direction != -newDirection) {
      direction = newDirection;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    debugPrint(other.runtimeType.toString());
    switch (other) {
      case Food():
        addNewBody = true;
        break;

      case Snake():
        debugPrint("game over");
        break;

      default:
    }
  }
}

class SnakeBody extends PositionComponent {
  late Paint paint;
  double snakeSize = 20;
  late RectangleHitbox hitbox;

  SnakeBody(Vector2 position) {
    this.position = position;
    paint = Paint()..color = Colors.blue;
    hitbox = RectangleHitbox(
      size: Vector2(snakeSize - 10, snakeSize - 10),
      position: Vector2(5, 5),
      isSolid: true,
    );
    add(hitbox);
  }

  @override
  void update(double dt) {}
}
