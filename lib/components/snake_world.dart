import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:snake_flame_engine_flutter/components/board.dart';
import 'package:snake_flame_engine_flutter/components/food.dart';
import 'package:snake_flame_engine_flutter/components/snake.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';
import 'package:snake_flame_engine_flutter/models/snake_direction.dart';

class SnakeWorld extends World {
  SnakeWorld({super.children, super.priority, required this.gameRef});
  final SnakeGame gameRef;

  late Snake snake;
  late Food food;
  late Board board;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    debugMode = false;

    const myAnchor = Anchor.topLeft;

    board = Board(gameRef, boardSize: gameRef.size);
    board.anchor = myAnchor;
    add(board);

    food = Food(gameRef);
    food.anchor = myAnchor;
    add(food);

    snake = Snake(gameRef, food: food, beginningSnakeSize: 3);
    snake.anchor = myAnchor;
    add(snake);

    snake.loaded.then((value) {
      gameRef.pauseEngine();
    });
  }

  void setDirection(SnakeDirection direction) {
    snake.setDirection(direction);
  }

  void restart() {
    remove(snake);
    snake = Snake(gameRef, food: food, beginningSnakeSize: 3);
    add(snake);

    food.randomizePosition([snake.head, food.position]);
  }

  void gestureHandler(DragEndInfo info) {
    final velocityX = info.velocity.x.abs();
    final velocityY = info.velocity.y.abs();
    if (velocityX > velocityY) {
      if (info.velocity.x > 0) {
        snake.setDirection(SnakeDirection.right);
      } else {
        snake.setDirection(SnakeDirection.left);
      }
    }
    if (velocityY > velocityX) {
      if (info.velocity.y > 0) {
        snake.setDirection(SnakeDirection.down);
      } else {
        snake.setDirection(SnakeDirection.up);
      }
    }
  }
}
