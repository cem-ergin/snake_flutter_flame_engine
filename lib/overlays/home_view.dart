import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';

class HomeView extends StatelessWidget {
  static const String id = 'HomeView';
  const HomeView({super.key, required this.gameRef});

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
              },
              child: const Text('Start Game'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement settings chooser logic
              },
              child: const Text('Settings Chooser'),
            ),
          ],
        ),
      ),
    );
  }
}
