import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:snake_flame_engine_flutter/components/food.dart';
import 'package:snake_flame_engine_flutter/components/snake.dart';

class SnakeGame extends FlameGame with PanDetector, HasCollisionDetection {
  late Snake snake;
  late Food food;

  SnakeGame() {
    // updateInterval = 50;
  }

  @override
  Future<void> onLoad() async {
    debugMode = true;

    snake = Snake(this);
    add(snake);

    food = Food(this)..randomizePosition();
    add(food);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    super.onPanEnd(info);
    gestureHandler(info);
  }

  void gestureHandler(DragEndInfo info) {
    final velocityX = info.velocity.x.abs();
    final velocityY = info.velocity.y.abs();
    if (velocityX > velocityY) {
      if (info.velocity.x > 0) {
        snake.setDirection(Vector2(20, 0));
      } else {
        snake.setDirection(Vector2(-20, 0));
      }
    }
    if (velocityY > velocityX) {
      if (info.velocity.y > 0) {
        snake.setDirection(Vector2(0, 20));
      } else {
        snake.setDirection(Vector2(0, -20));
      }
    }
  }
}
