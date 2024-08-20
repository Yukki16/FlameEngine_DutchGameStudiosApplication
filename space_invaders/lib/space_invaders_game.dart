import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:space_invaders/bloc/game_bloc.dart';
import 'package:space_invaders/components/enemy_spawner.dart';
import 'package:space_invaders/components/player_component.dart';
import 'package:space_invaders/components/player_states.dart';

class SpaceInvadersGame extends FlameGame
    with KeyboardEvents, PanDetector, HasCollisionDetection {
  late PlayerComponent player;
  late EnemySpawner spawner;

  final GameBloc _gameBloc;

  SpaceInvadersGame(this._gameBloc);

  late TextComponent info;
  late TextComponent enemyKilled;
  late TextComponent lifeText;
  late TextComponent gameStatus;
  late TextComponent finalMessage;
  bool finalMessageAdded = false;

  @override
  Future<void> onLoad() async {
    await FlameAudio.audioCache
        .loadAll(['backgroundMusic/SI_original_st.wav', 'SFX/explosion.wav']);
    FlameAudio.bgm.initialize();
    await FlameAudio.bgm
        .play('backgroundMusic/SI_original_st.wav', volume: 0.15);

    gameStatus = TextComponent(
        text: _gameBloc.state.status.toString(),
        position: Vector2(10, 10),
        anchor: Anchor.topLeft);
    add(gameStatus);

    lifeText = TextComponent(
        text: 'Lifes: ${_gameBloc.state.numberOfLifes}',
        position: Vector2(10, 30),
        anchor: Anchor.topLeft);
    add(lifeText);

    enemyKilled = TextComponent(
        text: 'Enemies killed: ${_gameBloc.state.numberOfEnemiesKilled}',
        position: Vector2(10, 50),
        anchor: Anchor.topLeft);
    add(enemyKilled);

    info = TextBoxComponent(
        text: "'L': Change enemy movement \n 'P': Change game state",
        position: Vector2(size.x, 10),
        anchor: Anchor.topRight);
    add(info);
    gameRestarted();
  }

  @override
  void update(double dt) {
    super.update(dt);
    gameStatus.text = _gameBloc.state.status.toString();
    lifeText.text = 'Lifes: ${_gameBloc.state.numberOfLifes}';
    enemyKilled.text =
        'Enemies killed: ${_gameBloc.state.numberOfEnemiesKilled}';
  }

  void gameOver() {
    //print('game over');
    remove(spawner);
    remove(player);
    add(finalMessage = TextComponent(
      text: _gameBloc.state.message,
      position: size / 2,
      anchor: Anchor.center,
    ));
    finalMessageAdded = true;
  }

  void gameRestarted() async {
    //print('I get invoked');
    await add(player = PlayerComponent(gameBloc: _gameBloc, currentState: PlayingState()));
    await add(spawner = EnemySpawner(gameBloc: _gameBloc));
    _gameBloc.add(StartGameEvent());
    if (finalMessageAdded) // I should make a list of game objects that are added to the game, but this is a faster solution
    {
      remove(finalMessage);
      finalMessageAdded = false;
    }

    //add(gameStatus);
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (_gameBloc.state.status == GameStatus.playing) {
      player.onKeyEvent(event, keysPressed);
      spawner.onKeyEvent(event, keysPressed);
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyP)) {
      switch (_gameBloc.state.status) {
        case GameStatus.gameOver:
          _gameBloc.add(RestartGameEvent());
          break;

        case GameStatus.playing:
          _gameBloc.add(EndGameEvent("Status changed to gameOver"));
          break;

        default:
          _gameBloc.add(EndGameEvent("Entered from default"));
          break;
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onPanStart(_) {
    if (_gameBloc.state.status == GameStatus.playing && player.currentState is PlayingState) {
      player.beginShooting();
    }
  }

  @override
  void onPanEnd(_) {
    if (_gameBloc.state.status == GameStatus.playing && player.currentState is PlayingState) {
      player.stopShooting();
    }
  }

  @override
  void onPanCancel() {
    if (_gameBloc.state.status == GameStatus.playing && player.currentState is PlayingState) {
      player.stopShooting();
    }
  }
}
