import 'dart:async';
import 'dart:js_interop_unsafe';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_invaders/bloc/game_bloc.dart';
import 'package:space_invaders/components/enemy_spawner.dart';
import 'package:space_invaders/components/player_component.dart';

class SpaceInvadersGame extends FlameGame
    with KeyboardEvents, PanDetector, HasCollisionDetection {

  late PlayerComponent player;
  late EnemySpawner spawner;

  final GameBloc _gameBloc;

  SpaceInvadersGame(this._gameBloc);

  late TextComponent gameStatus;
  late TextComponent finalMessage;

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache
        .loadAll(['backgroundMusic/SI_original_st.wav', 'SFX/explosion.wav']);
    FlameAudio.bgm.initialize();
    await FlameAudio.bgm
        .play('backgroundMusic/SI_original_st.wav', volume: 0.15);
    //await add(player = PlayerComponent());
    //await add(spawner = EnemySpawner());
    //FlameAudio.bgm.initialize();
    gameStatus = TextComponent(text: _gameBloc.state.status.toString(), position: Vector2(10, 10), anchor: Anchor.topLeft);
    add(gameStatus);

    gameRestarted();
    //_gameBloc.add(StartGameEvent());
    // if(_gameBloc.state.status == GameStatus.waiting)
    // {
    //   gameRestarted();
    // }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  void gameOver() {
    //print('game over');
    remove(spawner);
    remove(player);
    add(finalMessage = TextComponent(text: _gameBloc.state.message, position: size / 2, anchor: Anchor.center, ));
  }

  void gameRestarted() async {
    //print('I get invoked');
    await add(player = PlayerComponent(gameBloc: _gameBloc));
    await add(spawner = EnemySpawner());
    _gameBloc.add(StartGameEvent());
    finalMessage = TextComponent(text: '', position: size / 2, anchor: Anchor.center);
    gameStatus.text = _gameBloc.state.status.toString();
    
    //add(gameStatus);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (_gameBloc.state.status == GameStatus.playing) {
      player.onKeyEvent(event, keysPressed);
      spawner.onKeyEvent(event, keysPressed);
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onPanStart(_) {
    if (_gameBloc.state.status == GameStatus.playing) {
      player.beginShooting();
    }
  }

  @override
  void onPanEnd(_) {
    if (_gameBloc.state.status == GameStatus.playing) {
      player.stopShooting();
    }
  }

  @override
  void onPanCancel() {
    if (_gameBloc.state.status == GameStatus.playing) {
      player.stopShooting();
    }
  }
}
