import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:space_invaders/components/enemy_component.dart';

class EnemySpawner extends TimerComponent with HasGameRef, KeyboardHandler {
  int numberOfEnemies = 4;

  MovingStrategy _movingStrategy = MovingStrategy.linear;

  EnemySpawner() : super(period: 2, repeat: true);

  Random random = Random();
  @override
  void onTick() {
    // TODO: implement onTick
    super.onTick();
   game.addAll(List.generate(numberOfEnemies, (index) => EnemyComponent(movingStrategy: 
    (_movingStrategy == MovingStrategy.linear?LinearMovement():
    (
      _movingStrategy == MovingStrategy.wavy?WavyMovemnt():
      (random.nextBool()?LinearMovement():WavyMovemnt()))
    ), position: Vector2((game.size.x / numberOfEnemies) * index, 0))));
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed)
  {
    if(keysPressed.contains(LogicalKeyboardKey.keyL))
    {
      _movingStrategy = getNextMovingStrategy(_movingStrategy);
      //print("strategy Changed");
    }
    return true;
  }
  
  MovingStrategy getNextMovingStrategy(MovingStrategy currentStrategy)
  {
    const allValues = MovingStrategy.values;
    final currentIndex = currentStrategy.index;
    final nextIndex = (currentIndex + 1) % allValues.length;
    return allValues[nextIndex];
  }
}


abstract class EnemyMovingStrategy
{
  void move(EnemyComponent enemy, double speed, double dt);
}

class LinearMovement implements EnemyMovingStrategy{
  @override
  void move(EnemyComponent enemy, double speed, double dt) {
    enemy.position += enemy.direction * speed * dt;
  }
}

class WavyMovemnt implements EnemyMovingStrategy
{
  double time = 1;
  @override
  void move(EnemyComponent enemy, double speed, double dt) {
    time += dt;
    //direction.x = sin(time * 2 * pi) * 150;
    enemy.direction.x = sin(time);
    enemy.position += enemy.direction * speed * dt;
  }
}

enum MovingStrategy{
  linear,
  wavy,
  mixed
}
