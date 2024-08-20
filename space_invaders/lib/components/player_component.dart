import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_invaders/bloc/game_bloc.dart';
import 'package:space_invaders/components/bullet_pool.dart';
import 'package:space_invaders/components/enemy_component.dart';
import 'package:space_invaders/components/player_states.dart';

class PlayerComponent extends SpriteComponent with HasGameRef, CollisionCallbacks, KeyboardHandler{

  final double speed = 200.0; //Player speed

  //late BulletPool _bulletPool; //Pool design pattern to reuse bullets
  late TimerComponent bulletCreator;

  Vector2 direction = Vector2.zero(); //Vector to modify direction of movement

  //Refrence to the BLOC for game state management
  late GameBloc gameBloc;

  PlayerComponent({required this.gameBloc, required this.currentState}) : super();

  PlayerState currentState;
  
  /// Sprites
  
  late Sprite idleSprite;
  late Sprite movingLeftSprite;
  late Sprite movingRightSprite;

  /// 


  /// Effect variables
  
  double duration = 0.1;
  double reverseDuration = 0.1;
  int repeat = 3;

  ///

  @override
  Future<void> onLoad() async {

    //_bulletPool = BulletPool(5);

    final spriteSheet = await gameRef.images.load('spaceShip.png');
    idleSprite = Sprite(spriteSheet, srcSize: Vector2(8,8), srcPosition: Vector2(0, 0));
    movingLeftSprite = Sprite(spriteSheet, srcSize: Vector2(8,8), srcPosition: Vector2(8,0));
    movingRightSprite = Sprite(spriteSheet, srcSize: Vector2(8,8), srcPosition: Vector2(16,0));

    sprite = idleSprite;
    size = Vector2(32, 32);
    position.x = game.size.x / 2;
    position.y = game.size.y / 3 * 2;
    add(CircleHitbox());

    add(bulletCreator = TimerComponent(period: 0.2, repeat: true, autoStart: false, onTick: shootBullet));
  }

  void changeState(PlayerState newPlayerState)
  {
    currentState.exit(this);
    currentState = newPlayerState;
    currentState.enter(this);
  }

  void shootBullet()
  {
    final bullet = BulletPool.intance.getBullet(position, Vector2(0, -1));
    game.add(bullet);
  }

  void beginShooting()
  {
    bulletCreator.timer.start();
  }

  void stopShooting()
  {
    bulletCreator.timer.stop();
  }

  //Shoots a bullet out of the pool for bullets
  @override
  void update(double dt) {
    super.update(dt);
    currentState.update(this, dt);

    //The following code has been moved to player state - PlayingState
    // position += direction * dt * speed; 
    // for (final bullet in game.children.whereType<BulletComponent>().toList()) {
    //   if (bullet.position.y < 0 || bullet.position.y > game.size.y) {
    //     BulletPool.intance.releaseBullet(bullet);
    //     game.remove(bullet);
    //   }
    // }
  }

  //Moving with A/D event
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        direction.x = -1; // Move left
        sprite = movingLeftSprite;
      } 
      else
      if (keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        direction.x = 1; // Move right
        sprite = movingRightSprite;
      }
      // else
      // {
      //   direction.x = 0; //Stop moving
      //   sprite = idleSprite;
      // }
    }
    else
    if(event is KeyUpEvent)
    {
      if (!keysPressed.any((key) => key == LogicalKeyboardKey.keyA ||
                                         key == LogicalKeyboardKey.keyD ||
                                         key == LogicalKeyboardKey.arrowLeft ||
                                         key == LogicalKeyboardKey.arrowRight))
      {
        direction.x = 0; //Stop moving
        sprite = idleSprite;
      }
    }
    position.x = position.x.clamp(0, game.size.x - size.x);
    return true;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {

    super.onCollisionStart(intersectionPoints, other);
    if(other is EnemyComponent)
    {
      other.takeHit();
      addHitEffect();


      gameBloc.add(LoseALifeEvent());
      if(gameBloc.nrOfLifes <= 0)
      {
        gameBloc.add(EndGameEvent("You lost"));
      }
    }
  }

  void addHitEffect()
  {
    final colorEffect = ColorEffect(Colors.red, EffectController(duration: duration, reverseDuration: reverseDuration, repeatCount: repeat));
    add(colorEffect);
    
    changeState(HitState(timeAsHit: (duration + reverseDuration) * repeat));
  }
}