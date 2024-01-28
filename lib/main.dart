import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:snake_flame_engine_flutter/game/snake_game.dart';
import 'package:snake_flame_engine_flutter/overlays/game_finished_view.dart';
import 'package:snake_flame_engine_flutter/overlays/game_over_view.dart';
import 'package:snake_flame_engine_flutter/overlays/home_view.dart';
import 'package:snake_flame_engine_flutter/overlays/pause_view.dart';

// final gameSize = Vector2(600, 600);
final gameSize = Vector2(80, 80);
const snakeSize = 20.0;

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final snakeGame = SnakeGame();
    return MaterialApp(
      theme: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white.withOpacity(.5),
      ),
      home: SafeArea(
        child: GameWidget.controlled(
          gameFactory: () => snakeGame,
          initialActiveOverlays: const [HomeView.id],
          overlayBuilderMap: {
            HomeView.id: (context, game) => HomeView(
                  gameRef: snakeGame,
                ),
            PauseView.id: (context, game) => PauseView(
                  gameRef: snakeGame,
                ),
            GameOverView.id: (context, game) => GameOverView(
                  gameRef: snakeGame,
                ),
            GameFinishedView.id: (context, game) => GameFinishedView(
                  gameRef: snakeGame,
                ),
          },
        ),
      ),
    );
  }
}
