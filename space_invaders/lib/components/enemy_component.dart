import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:space_invaders/bloc/game_bloc.dart';
import 'package:space_invaders/components/enemy_spawner.dart';

class EnemyComponent extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks{

  static const double speed = 100;
  Vector2 direction = Vector2(0, 1);

 late EnemyMovingStrategy movingStrategy;

  late GameBloc gameBloc;
  EnemyComponent({required EnemyMovingStrategy movingStrategy, required super.position, required this.gameBloc})
  {
    this.movingStrategy = movingStrategy;
  }

  @override 
  Future<void> onLoad() async{
    animation = await game.loadSpriteAnimation('enemy.png', SpriteAnimationData.sequenced(amount: 2, stepTime: 0.25, textureSize: Vector2(8,8)));
    size = Vector2(32, 32);

    decorator.addLast(PaintDecorator.tint(getRandomColor())); //Decorator added to have enemies of different colors
                                                              //None of the sprites I used has a transparent background :/. so the decorator applies to the black background
                                                              //they have too as you can see 
    
    //animation?.addDecorator(decorator);
    add(CircleHitbox());
  }

  Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(125, random.nextInt(256),  random.nextInt(256), random.nextInt(256));
}

  @override
  void update(double dt) {
    super.update(dt);
    movingStrategy.move(this, speed, dt);
    if(position.y > game.size.y)
    {
      game.remove(this);
    }
  }

  void takeHit() {
    Random rnd = Random();

    Vector2 randomVector2() => (Vector2.random(rnd) - Vector2.random(rnd)) * 200;

    game.add(ParticleSystemComponent(particle: Particle.generate(count: 10, 
                                    generator: (i) => AcceleratedParticle(position: position + Vector2(rnd.nextDouble() * 20 - 10, rnd.nextDouble() * 20 - 10),
                                    speed: randomVector2(), lifespan: 0.5,
                                    child: CircleParticle(radius: 3, paint: Paint()..color = Colors.red)))));
    
    FlameAudio.play('SFX/explosion.wav', volume: 0.15);
    gameBloc.add(KilledAnEnemyEvent());
    if(gameBloc.state.numberOfEnemiesKilled >= 10)
    {
      gameBloc.add(EndGameEvent("You win!"));
    }
    removeFromParent();
  }
}
