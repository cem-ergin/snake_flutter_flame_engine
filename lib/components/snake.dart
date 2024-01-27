import 'dart:async';

import 'package:flame/collisions.dart';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/components/food.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';
import 'package:snake_flame_engine_flutter/main.dart';
import 'package:snake_flame_engine_flutter/models/snake_direction.dart';
import 'package:snake_flame_engine_flutter/overlays/game_over_view.dart';

class Snake extends PositionComponent with CollisionCallbacks {
  late Paint headPaint;
  late Paint bodyPaint;
  late Vector2 head;
  late SnakeDirection direction;
  late RectangleHitbox hitbox;
  late List<SnakeBody> snakeBody;
  bool addNewBody = false;
  double updateTime = 0;

  Snake(this.gameRef, {required this.food, required this.beginningSnakeSize});

  final SnakeGame gameRef;
  final Food food;
  final int beginningSnakeSize;

  @override
  FutureOr<void> onLoad() {
    headPaint = Paint()..color = Colors.orange;
    bodyPaint = Paint()..color = Colors.grey;
    head = Vector2(0, 0);
    direction = SnakeDirection.right;
    hitbox = RectangleHitbox(
      position: Vector2(head.x + 5, head.y + 5),
      size: Vector2(snakeSize - 10, snakeSize - 10),
      isSolid: true,
    );
    add(hitbox);

    snakeBody = [];
    if (beginningSnakeSize > 0) {
      for (var i = 0; i < beginningSnakeSize - 1; i++) {
        final newBody = SnakeBody(Vector2(direction.opposite.vector.x * (i + 1), 0));
        snakeBody.add(newBody);
        add(newBody);
      }
    }

    return super.onLoad();
  }

  setAddNewBody({required bool value}) {
    addNewBody = value;
  }

  @override
  void render(Canvas canvas) {
    _draw(
      canvas,
      Rect.fromPoints(
        head.toOffset(),
        head.toOffset() + Vector2(snakeSize, snakeSize).toOffset(),
      ),
      headPaint,
    );

    for (var body in snakeBody) {
      if (isPositionInsideOffset(body.position)) {
        _draw(
          canvas,
          Rect.fromPoints(
            body.position.toOffset(),
            body.position.toOffset() + Vector2(snakeSize, snakeSize).toOffset(),
          ),
          bodyPaint,
        );
      }
    }
  }

  void _draw(Canvas canvas, Rect rect, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        bottomLeft: const Radius.circular(6),
        bottomRight: const Radius.circular(6),
        topLeft: const Radius.circular(6),
        topRight: const Radius.circular(6),
      ),
      paint,
    );
  }

  bool isPositionInsideOffset(Vector2 position) {
    return position.x >= 0 && position.y >= 0 && position.x < gameRef.size.x && position.y < gameRef.size.y;
  }

  @override
  void update(double dt) {
    if (updateTime < 0.5) {
      updateTime += dt;
      return;
    }
    updateTime = 0;

    if (addNewBody) {
      addBody();
      setAddNewBody(value: false);
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
    final newHead = head + direction.vector;
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
    final gameX = gameRef.canvasSize.x;
    final gameY = gameRef.canvasSize.y;
    final divideX = gameX ~/ snakeSize.ceil();
    final divideY = gameY ~/ snakeSize.ceil();
    final finalSizeX = divideX * snakeSize;
    final finalSizeY = divideY * snakeSize;

    if (newHead.x >= gameX) {
      newHead.x = 0;
    }
    if (newHead.x <= -snakeSize) {
      newHead.x = finalSizeX - snakeSize;
    }
    if (newHead.y >= gameY) {
      newHead.y = 0;
    }
    if (newHead.y <= -snakeSize) {
      newHead.y = finalSizeY - snakeSize;
    }
  }

  void setDirection(SnakeDirection newDirection) {
    if (direction == newDirection.opposite) {
      return;
    }
    direction = newDirection;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    debugPrint(other.runtimeType.toString());
    switch (other) {
      case Food():
        setAddNewBody(value: true);
        food.randomizePosition([head, ...snakeBody.map((body) => body.position).toList()]);
        break;

      case SnakeBody():
        gameRef.pauseEngine();
        gameRef.overlays.add(GameOverView.id);
        break;

      default:
    }
  }
}

class SnakeBody extends PositionComponent {
  late RectangleHitbox hitbox;

  SnakeBody(Vector2 position) {
    this.position = position;
    print('position: $position');
    hitbox = RectangleHitbox(
      size: Vector2(snakeSize - 10, snakeSize - 10),
      position: Vector2(5, 5),
      isSolid: true,
    );
    add(hitbox);
  }
}
