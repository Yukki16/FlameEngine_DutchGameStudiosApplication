part of 'game_bloc.dart';

abstract class GameEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class StartGameEvent extends GameEvent{

}

class RestartGameEvent extends GameEvent{

}

class EndGameEvent extends GameEvent{
  final String endMessage;
  String get _endMessage => endMessage;
  EndGameEvent(this.endMessage);
}

class LoseALifeEvent extends GameEvent{

}