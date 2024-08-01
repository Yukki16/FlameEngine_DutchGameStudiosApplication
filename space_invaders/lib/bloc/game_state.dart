part of 'game_bloc.dart';

class GameState extends Equatable{

  const GameState({required this.status, required this.numberOfLifes, required this.message, required this.numberOfEnemiesKilled});

  const GameState.initial(): status = GameStatus.waiting, numberOfLifes = 3, message = "If you see this check to update this message", numberOfEnemiesKilled = 0;

  GameState copyWith({GameStatus? status, int? numberOfLifes, String? message, int? numberOfEnemiesKilled})
  {
    return GameState(status: status?? this.status,
                     numberOfLifes: numberOfLifes?? this.numberOfLifes,
                     message: message?? this.message,
                     numberOfEnemiesKilled: numberOfEnemiesKilled?? this.numberOfEnemiesKilled);
  }

  final GameStatus status;
  final int numberOfLifes;
  final String message;
  final int numberOfEnemiesKilled;


  @override
    List<Object> get props => [status, numberOfLifes, message, numberOfEnemiesKilled];
}

enum GameStatus
{
  waiting,
  playing,
  gameOver
}