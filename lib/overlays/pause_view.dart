import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';

class PauseView extends StatelessWidget {
  static const String id = 'PauseView';
  const PauseView({super.key, required this.gameRef});

  final SnakeGame gameRef;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(id);
                gameRef.resumeEngine();
              },
              child: const Text('Resume'),
            ),
            const SizedBox(height: 16),
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
