import 'package:flame/components.dart';
import 'package:space_invaders/components/bullet_component.dart';

class BulletPool {
  final List<BulletComponent> _available = [];
  final List<BulletComponent> _inUse = [];

  BulletPool(int initialSize) {
    for (int i = 0; i < initialSize; i++) {
      _available.add(BulletComponent(direction: Vector2.zero(), position: Vector2.zero()));
    }
  }

  BulletComponent getBullet(Vector2 position, Vector2 direction) {
    if (_available.isNotEmpty) {
      final bullet = _available.removeLast();
     bullet.reset(position, direction);
      _inUse.add (bullet);
      return bullet;
    } else {
      // Optionally create a new bullet if the pool is empty
      final bullet = BulletComponent(direction: direction, position: position);
      _inUse.add (bullet);
      return bullet;
    }
  }

  void releaseBullet(BulletComponent bullet) {
    _inUse.remove (bullet);
    _available.add (bullet);
  }
}