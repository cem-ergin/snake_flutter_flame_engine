import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';

class GameFinishedView extends StatelessWidget {
  static const String id = 'GameFinishedView';
  const GameFinishedView({super.key, required this.gameRef});

  final SnakeGame gameRef;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(
                child: Text(
                  'Congratulations! You Won!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    gameRef.restart();
                    gameRef.overlays.remove(id);
                    gameRef.resumeEngine();
                  },
                  child: const Text('Restart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
