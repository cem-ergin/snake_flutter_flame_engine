import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/components/food.dart';
import 'package:snake_flame_engine_flutter/components/snake.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';
import 'package:snake_flame_engine_flutter/main.dart';
import 'package:snake_flame_engine_flutter/models/snake_direction.dart';

class Board extends PositionComponent {
  final Vector2 boardSize;
  late Paint white;
  late Paint red;
  final SnakeGame gameRef;

  late Snake snake;
  late Food food;
  late Board board;

  Board(this.gameRef, {super.children, super.priority, super.key, required this.boardSize});

  @override
  FutureOr<void> onLoad() {
    super.onLoad();
    debugMode = false;

    position = gameRef.size / 2 - boardSize;
    white = Paint()..color = Colors.grey.withOpacity(.3);
    red = Paint()..color = Colors.blue.withOpacity(.3);

    const myAnchor = Anchor.topLeft;

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
