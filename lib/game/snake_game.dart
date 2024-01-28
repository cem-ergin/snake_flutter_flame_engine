import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_flame_engine_flutter/components/board.dart';
import 'package:snake_flame_engine_flutter/main.dart';
import 'package:snake_flame_engine_flutter/models/snake_direction.dart';
import 'package:snake_flame_engine_flutter/overlays/pause_view.dart';

class SnakeGame extends FlameGame with PanDetector, HasCollisionDetection, KeyboardEvents {
  late Board board;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    debugMode = false;

    const myAnchor = Anchor.topLeft;
    camera = CameraComponent(world: world, viewport: FixedSizeViewport(800, 600));
    board = Board(this, boardSize: gameSize);
    board.anchor = myAnchor;
    world.add(board);

    size.setValues(gameSize.x, gameSize.y);
    canvasSize.setValues(gameSize.x, gameSize.y);
  }

  @override
  Color backgroundColor() {
    super.backgroundColor();
    return Colors.blue.withOpacity(.05);
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
      board.snake.setDirection(SnakeDirection.up);
    }
    if (keyId == LogicalKeyboardKey.arrowDown.keyId) {
      board.snake.setDirection(SnakeDirection.down);
    }
    if (keyId == LogicalKeyboardKey.arrowLeft.keyId) {
      board.snake.setDirection(SnakeDirection.left);
    }
    if (keyId == LogicalKeyboardKey.arrowRight.keyId) {
      board.snake.setDirection(SnakeDirection.right);
    }
  }

  void gestureHandler(DragEndInfo info) {
    final velocityX = info.velocity.x.abs();
    final velocityY = info.velocity.y.abs();
    if (velocityX > velocityY) {
      if (info.velocity.x > 0) {
        board.snake.setDirection(SnakeDirection.right);
      } else {
        board.snake.setDirection(SnakeDirection.left);
      }
    }
    if (velocityY > velocityX) {
      if (info.velocity.y > 0) {
        board.snake.setDirection(SnakeDirection.down);
      } else {
        board.snake.setDirection(SnakeDirection.up);
      }
    }
  }
}
