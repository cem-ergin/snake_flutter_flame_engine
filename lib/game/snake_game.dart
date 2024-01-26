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
import 'package:snake_flame_engine_flutter/overlays/pause_view.dart';

class SnakeGame extends FlameGame with PanDetector, HasCollisionDetection, KeyboardEvents {
  late Snake snake;
  late Food food;
  late Board board;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    debugMode = false;

    camera = CameraComponent(world: world, viewport: FixedSizeViewport(gameSize.x, gameSize.y));
    board = Board(boardSize: gameSize);
    add(board);

    food = Food(this);
    add(food);

    snake = Snake(this, food: food);
    add(snake);

    size.setValues(gameSize.x, gameSize.y);
    canvasSize.setValues(gameSize.x, gameSize.y);

    snake.loaded.then((value) {
      pauseEngine();
    });
  }

  @override
  void onParentResize(Vector2 maxSize) {
    print('onParentResize: $maxSize');
    if (isLoaded) {
      size.setFrom(gameSize);
      canvasSize.setFrom(gameSize);
    }
    super.onParentResize(maxSize);
  }

  @override
  void onGameResize(Vector2 size) {
    print('onGameResize: $size');
    if (isLoaded) {
      size.setFrom(gameSize);
      canvasSize.setFrom(gameSize);
    }
    super.onGameResize(size);
  }

  void restart() {
    remove(snake);
    snake = Snake(this, food: food);
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
      snake.setDirection(Vector2(0, -snakeSize));
    }
    if (keyId == LogicalKeyboardKey.arrowDown.keyId) {
      snake.setDirection(Vector2(0, snakeSize));
    }
    if (keyId == LogicalKeyboardKey.arrowLeft.keyId) {
      snake.setDirection(Vector2(-snakeSize, 0));
    }
    if (keyId == LogicalKeyboardKey.arrowRight.keyId) {
      snake.setDirection(Vector2(snakeSize, 0));
    }
  }

  void gestureHandler(DragEndInfo info) {
    final velocityX = info.velocity.x.abs();
    final velocityY = info.velocity.y.abs();
    if (velocityX > velocityY) {
      if (info.velocity.x > 0) {
        snake.setDirection(Vector2(snakeSize, 0));
      } else {
        snake.setDirection(Vector2(-snakeSize, 0));
      }
    }
    if (velocityY > velocityX) {
      if (info.velocity.y > 0) {
        snake.setDirection(Vector2(0, snakeSize));
      } else {
        snake.setDirection(Vector2(0, -snakeSize));
      }
    }
  }
}
