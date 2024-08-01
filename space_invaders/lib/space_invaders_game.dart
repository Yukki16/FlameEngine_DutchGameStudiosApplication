import 'dart:async';
import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_invaders/components/enemy_spawner.dart';
import 'package:space_invaders/components/player_component.dart';

class SpaceInvadersGame extends FlameGame with KeyboardEvents, PanDetector, HasCollisionDetection
{
  late PlayerComponent player;
  late EnemySpawner spawner;
  @override
  Future<void> onLoad() async 
  {
    await FlameAudio.audioCache.loadAll(['backgroundMusic/SI_original_st.wav','SFX/explosion.wav']);
    FlameAudio.bgm.initialize();
    await FlameAudio.bgm.play('backgroundMusic/SI_original_st.wav', volume: 0.15);
    add(player = PlayerComponent());
    add(spawner = EnemySpawner());
    //FlameAudio.bgm.initialize();
  }

  @override
  void update(double dt)
  {
    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    player.onKeyEvent(event, keysPressed);
    spawner.onKeyEvent(event, keysPressed);
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onPanStart(_) {
    player.beginShooting();
  }

  @override
  void onPanEnd(_) {
    player.stopShooting();
  }

  @override
  void onPanCancel() {
    player.stopShooting();
  }
}