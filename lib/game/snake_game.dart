import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_flame_engine_flutter/components/board.dart';
import 'package:snake_flame_engine_flutter/components/food.dart';
import 'package:snake_flame_engine_flutter/components/snake.dart';
import 'package:snake_flame_engine_flutter/main.dart';
import 'package:snake_flame_engine_flutter/models/snake_direction.dart';
import 'package:snake_flame_engine_flutter/overlays/pause_view.dart';

class SnakeGame extends FlameGame with PanDetector, HasCollisionDetection, KeyboardEvents {
  late Snake snake;
  late Food food;
  late Board board;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    debugMode = true;

    camera = CameraComponent(world: world, viewport: FixedSizeViewport(gameSize.x, gameSize.y));
    board = Board(boardSize: gameSize);
    add(board);

    food = Food(this);
    add(food);

    snake = Snake(this, food: food, beginningSnakeSize: 3);
    add(snake);

    size.setValues(gameSize.x, gameSize.y);
    canvasSize.setValues(gameSize.x, gameSize.y);

    snake.loaded.then((value) {
      pauseEngine();
    });
  }

  @override
  void onGameResize(Vector2 size) {
    if (isLoaded) {
      size.setFrom(gameSize);
      canvasSize.setFrom(gameSize);
    }
    super.onGameResize(size);
  }

  void restart() {
    remove(snake);
    snake = Snake(this, food: food, beginningSnakeSize: 3);
    add(snake);

    food.randomizePosition([snake.head, food.position]);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    super.onPanEnd(info);
    gestureHandler(info);
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDownEvent = event.runtimeType.toString() == 'RawKeyDownEvent';
    final keyId = event.logicalKey.keyId;
    if (isKeyDownEvent) {
      _handleDirections(keyId);
      _handlePause(keyId);
    }
    return KeyEventResult.handled;
  }

  void _handlePause(int keyId) {
    if (keyId == LogicalKeyboardKey.space.keyId || keyId == LogicalKeyboardKey.escape.keyId) {
      if (overlays.isActive(PauseView.id)) {
        overlays.remove(PauseView.id);
        resumeEngine();
      } else {
        pauseEngine();
        overlays.add(PauseView.id);
      }
    }
  }

  void _handleDirections(int keyId) {
    if (keyId == LogicalKeyboardKey.arrowUp.keyId) {
      snake.setDirection(SnakeDirection.up);
    }
    if (keyId == LogicalKeyboardKey.arrowDown.keyId) {
      snake.setDirection(SnakeDirection.down);
    }
    if (keyId == LogicalKeyboardKey.arrowLeft.keyId) {
      snake.setDirection(SnakeDirection.left);
    }
    if (keyId == LogicalKeyboardKey.arrowRight.keyId) {
      snake.setDirection(SnakeDirection.right);
    }
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
