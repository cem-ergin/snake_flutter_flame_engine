import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';
import 'package:snake_flame_engine_flutter/main.dart';
import 'package:snake_flame_engine_flutter/overlays/game_finished_view.dart';
import 'package:snake_flame_engine_flutter/overlays/game_over_view.dart';

class Food extends PositionComponent {
  late Paint paint;
  late SnakeGame gameRef;
  late RectangleHitbox hitbox;
  final random = Random();

  Food(this.gameRef);

  void randomizePosition(List<Vector2> occupiedPositions) {
    final canvasSize = gameRef.canvasSize.toSize();

    List<Vector2> availablePositions = [];

    for (int x = 0; x < canvasSize.width; x += snakeSize.toInt()) {
      for (int y = 0; y < canvasSize.height; y += snakeSize.toInt()) {
        Vector2 position = Vector2(x.toDouble(), y.toDouble());
        bool isOccupied = occupiedPositions.any(
          (pos) => (pos.x - position.x).abs() < snakeSize && (pos.y - position.y).abs() < snakeSize,
        );
        if (!isOccupied) {
          availablePositions.add(position);
        }
      }
    }

    if (availablePositions.isNotEmpty) {
      final randomPosition = availablePositions[random.nextInt(availablePositions.length)];
      position = randomPosition / 2;
      hitbox.position = position;
    } else {
      gameRef.overlays.add(GameFinishedView.id);
      gameRef.pauseEngine();
      return;
    }
  }

  @override
  FutureOr<void> onLoad() {
    hitbox = RectangleHitbox(isSolid: true, size: Vector2(20, 20));
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
