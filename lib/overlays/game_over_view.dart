import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';

class GameOverView extends StatelessWidget {
  static const String id = 'GameOverView';
  const GameOverView({super.key, required this.gameRef});

  final SnakeGame gameRef;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Over',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                gameRef.restart();
                gameRef.overlays.remove(id);
                gameRef.resumeEngine();
              },
              child: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
