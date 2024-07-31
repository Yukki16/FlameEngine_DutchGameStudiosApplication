import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:space_invaders/components/enemy_spawner.dart';

class EnemyComponent extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks{

  static const double speed = 100;
  Vector2 direction = Vector2(0, 1);

  EnemyMovingStrategy movingStrategy = LinearMovement();

  EnemyComponent({required EnemyMovingStrategy movingStrategy, required super.position});

  @override 
  Future<void> onLoad() async{
    animation = await game.loadSpriteAnimation('enemy.png', SpriteAnimationData.sequenced(amount: 2, stepTime: 0.25, textureSize: Vector2(8,8)));
    size = Vector2(32, 32);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
    movingStrategy.move(this, speed, direction, dt);
    if(position.y > game.size.y)
    {
      game.remove(this);
    }
  }
}
