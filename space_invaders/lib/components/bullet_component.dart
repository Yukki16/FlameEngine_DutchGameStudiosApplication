import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class BulletComponent extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks{
  
  static const double speed = 300.0; //Bullet speed
  Vector2 direction = Vector2(0, 1);

  BulletComponent({required super.position, required this.direction});


  @override
  Future<void> onLoad() async {
    animation = await game.loadSpriteAnimation('projectile.png', SpriteAnimationData.sequenced(amount: 3, stepTime: 0.1, textureSize: Vector2(8,8)));
    size = Vector2(32,32);
    add(CircleHitbox());
  }

  @override
  void update(double dt) {  
    super.update(dt);
    position += direction * speed * dt;
  }

  void reset(Vector2 _position, Vector2 _direction)
  {
    position = _position;
    direction = _direction;
  }
}