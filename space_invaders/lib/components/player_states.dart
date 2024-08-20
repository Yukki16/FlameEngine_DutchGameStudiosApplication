import 'package:space_invaders/components/bullet_component.dart';
import 'package:space_invaders/components/bullet_pool.dart';
import 'package:space_invaders/components/player_component.dart';

abstract class PlayerState
{
  void enter(PlayerComponent player);
  void update(PlayerComponent player, double dt);
  void exit(PlayerComponent player);
}

class HitState implements PlayerState
{
  double timeElapsed = 0;
  double timeAsHit;

  HitState({required this.timeAsHit});

  @override
  void enter(PlayerComponent player) {
    // Nothing to change in this case
  }

  @override
  void exit(PlayerComponent player) {
    // TODO: implement exit
  }

  @override
  void update(PlayerComponent player, double dt) {
    timeElapsed += dt;
    if(timeElapsed >= timeAsHit)
    {
      player.changeState(PlayingState());
    }
  }
}

class PlayingState implements PlayerState
{
  @override
  void enter(PlayerComponent player) {
    // TODO: implement enter
  }

  @override
  void exit(PlayerComponent player) {
    // TODO: implement exit
  }

  @override
  void update(PlayerComponent player, double dt) {
    player.position += player.direction * dt * player.speed; 
    for (final bullet in player.game.children.whereType<BulletComponent>().toList()) {
      if (bullet.position.y < 0 || bullet.position.y > player.game.size.y) {
        BulletPool.intance.releaseBullet(bullet);
        player.game.remove(bullet);
      }
    }
  }
}