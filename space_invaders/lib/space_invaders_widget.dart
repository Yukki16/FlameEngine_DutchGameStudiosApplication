import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:space_invaders/space_invaders_game.dart';

class SpaceInvadersWidget extends StatelessWidget
{
  const SpaceInvadersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: SpaceInvadersGame(),
      loadingBuilder: (_) => const Center(
        child: Text('Loading'),
      ),
    );
  }
}