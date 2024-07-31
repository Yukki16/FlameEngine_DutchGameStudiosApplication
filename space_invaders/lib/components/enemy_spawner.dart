import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:space_invaders/components/enemy_component.dart';

class EnemySpawner extends TimerComponent with HasGameRef, KeyboardHandler {
  int numberOfEnemies = 4;

  MovingStrategy _movingStrategy = MovingStrategy.linear;

  EnemySpawner() : super(period: 1, repeat: true);

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
    ), position: Vector2(game.size.x / (index + 1), 0))));
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed)
  {
    if(keysPressed.contains(LogicalKeyboardKey.keyL))
    {
      _movingStrategy = getNextMovingStrategy(_movingStrategy);
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
  void move(EnemyComponent enemy, double speed, Vector2 direction, double dt);
}

class LinearMovement implements EnemyMovingStrategy{
  @override
  void move(EnemyComponent enemy, double speed, Vector2 direction, double dt) {
    enemy.position += direction * speed * dt;
  }
}

class WavyMovemnt implements EnemyMovingStrategy
{
  @override
  void move(EnemyComponent enemy, double speed, Vector2 direction, double dt) {
    direction.x = sin(dt * 15);
    enemy.position += direction * speed * dt;
  }
}

enum MovingStrategy{
  linear,
  wavy,
  mixed
}
