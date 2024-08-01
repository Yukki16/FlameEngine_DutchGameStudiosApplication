import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState>
{
  GameBloc() : super(const GameState.initial()){
    on<StartGameEvent>(_onStartOfGame);
    on<EndGameEvent>(_onGameOver);
    on<RestartGameEvent>(_onGameRestarted);
    on<LoseALifeEvent>(_onLoseALife);
    on<KilledAnEnemyEvent>(_onEnemyKilled);
  }

  int nrOfLifes = 3;

  void _onEnemyKilled(KilledAnEnemyEvent _, Emitter emit)
  {
    emit(state.copyWith(numberOfEnemiesKilled: state.numberOfEnemiesKilled + 1));
  }

  void _onStartOfGame(StartGameEvent _, Emitter emit)
  {
    //print('Started the game');
    nrOfLifes = 3;
    emit(const GameState.initial().copyWith(status: GameStatus.playing));
  }

  void _onLoseALife(LoseALifeEvent _, Emitter emit)
  {
    nrOfLifes--;
    emit(state.copyWith(numberOfLifes: nrOfLifes));
  }

  void _onGameRestarted(RestartGameEvent _, Emitter emit)
  {
    emit(state.copyWith(status: GameStatus.waiting));
  }

  void _onGameOver(EndGameEvent _, Emitter emit) 
  {
    emit(state.copyWith(status: GameStatus.gameOver, message: _._endMessage));
    //game.add(TextComponent(text: _gameBloc.state.status.toString(), position: Vector2(10, 10), anchor: Anchor.topLeft));
  }

}