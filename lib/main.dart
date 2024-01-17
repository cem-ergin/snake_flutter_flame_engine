import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GameWidget(
        game: SnakeGame(),
        overlayBuilderMap: {
          'PauseMenu': (context, game) {
            return Container(
              color: const Color(0xFF000000),
              child: const Text('A pause menu'),
            );
          },
        },
      ),
    );
  }
}
