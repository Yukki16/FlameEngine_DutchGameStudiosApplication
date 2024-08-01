part of 'game_bloc.dart';

class GameState extends Equatable{

  const GameState({required this.status, required this.numberOfLifes, required this.message});

  const GameState.initial(): status = GameStatus.waiting, numberOfLifes = 3, message = "If you see this check to update this message";

  GameState copyWith({GameStatus? status, int? numberOfLifes, String? message})
  {
    return GameState(status: status?? this.status,
                     numberOfLifes: numberOfLifes?? this.numberOfLifes,
                     message: message?? this.message);
  }

  final GameStatus status;
  final int numberOfLifes;
  final String message;

  @override
    List<Object> get props => [status, numberOfLifes, message];
}

enum GameStatus
{
  waiting,
  playing,
  gameOver
}