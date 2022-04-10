import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const pauseOverlayIdentifier = 'PauseMenu';
const controlsOverlayIdentifier = 'ControlsOverlay';

void main() {
  if (kDebugMode) {
    print('Loading the game widget...');
  }
  final myGame = MyGame()..paused = true;
  runApp(
    GameBackgroundWidget(
      child: GameWidget(
        game: myGame,
        overlayBuilderMap: const {
          pauseOverlayIdentifier: _pauseMenuBuilder,
          controlsOverlayIdentifier: _controlsOverlayBuilder,
        },
        initialActiveOverlays: const [
          pauseOverlayIdentifier,
          controlsOverlayIdentifier,
        ],
      ),
    ),
  );
}

class GameBackgroundWidget extends StatelessWidget {
  final Widget child;

  const GameBackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Flame Playground',
      home: Scaffold(
        body: Container(
          color: Colors.amber,
          child: child,
        ),
      ),
    );
  }
}

Widget _controlsOverlayBuilder(BuildContext buildContext, MyGame game) {
  return Positioned(
    right: 12,
    bottom: 12,
    child: Container(
      width: 50,
      height: 50,
      color: Colors.blue,
      child: const Center(
        child: Text('Button'),
      ),
    ),
  );
}

Widget _pauseMenuBuilder(BuildContext buildContext, MyGame game) {
  return Center(
    child: Container(
      width: 100,
      height: 100,
      color: Colors.orange,
      child: const Center(
        child: Text('Paused'),
      ),
    ),
  );
}

class MyGame extends FlameGame with SingleGameInstance, TapDetector {
  /// Transparent
  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    if (kDebugMode) {
      print('Loading game assets...');
      final animation = await loadSpriteAnimation(
        'animations/chopper.png',
        SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2.all(48),
          stepTime: 0.15,
        ),
      );

      final chopper = SpriteAnimationComponent(
        animation: animation,
        position: Vector2(100, size.y / 2),
        size: Vector2.all(100),
        anchor: Anchor.center,
      );

      add(chopper);
    }
  }

  @override
  void onTap() {
    if (overlays.isActive(pauseOverlayIdentifier)) {
      overlays.remove(pauseOverlayIdentifier);
      resumeEngine();
    } else {
      overlays.add(pauseOverlayIdentifier);
      pauseEngine();
    }
  }
}
