import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';

class HomeView extends StatelessWidget {
  static const String id = 'HomeView';
  const HomeView({super.key, required this.gameRef});

  final SnakeGame gameRef;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    gameRef.resumeEngine();
                    gameRef.overlays.remove(id);
                  },
                  child: const Text('Start'),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement settings chooser logic
                  },
                  child: const Text('Settings Chooser'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
