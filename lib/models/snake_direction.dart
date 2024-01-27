import 'package:flame/components.dart';
import 'package:snake_flame_engine_flutter/main.dart';

enum SnakeDirection {
  up,
  down,
  left,
  right;

  Vector2 get vector {
    switch (this) {
      case SnakeDirection.up:
        return Vector2(0, -snakeSize);
      case SnakeDirection.down:
        return Vector2(0, snakeSize);
      case SnakeDirection.left:
        return Vector2(-snakeSize, 0);
      case SnakeDirection.right:
        return Vector2(snakeSize, 0);
    }
  }

  SnakeDirection get opposite {
    switch (this) {
      case SnakeDirection.up:
        return SnakeDirection.down;
      case SnakeDirection.down:
        return SnakeDirection.up;
      case SnakeDirection.left:
        return SnakeDirection.right;
      case SnakeDirection.right:
        return SnakeDirection.left;
    }
  }
}
