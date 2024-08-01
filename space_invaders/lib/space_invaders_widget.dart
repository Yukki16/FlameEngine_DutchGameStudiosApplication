import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:space_invaders/bloc/game_bloc.dart';
import 'package:space_invaders/space_invaders_game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class SpaceInvadersWidget extends StatelessWidget
// {
//   const SpaceInvadersWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GameWidget(
//       game: SpaceInvadersGame(),
//       loadingBuilder: (_) => const Center(
//         child: Text('Loading'),
//       ),
//     );
//   }
// }

class MyGame extends StatelessWidget {

  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => GameBloc(),
        child: SpaceInvadersWidget(),
      ),
    );
  }
}

class SpaceInvadersWidget extends StatelessWidget {

  const SpaceInvadersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameBloc = context.read<GameBloc>();
    final game = SpaceInvadersGame(gameBloc);

    return Scaffold(
      body: BlocListener<GameBloc, GameState>(
        listener: (context, state) 
        {
          if (state.status == GameStatus.waiting) 
          {
            game.gameRestarted(); // Reset game when it starts or restarts
          } 
          else if (state.status == GameStatus.gameOver) 
          {
            print('Helllllllllooooo');
            game.gameOver(); // Handle game over logic
          }
        },
        child: Stack(
          children: [GameWidget(game: game),
            BlocBuilder<GameBloc, GameState>(builder: (context, state) 
            {
                if (state.status == GameStatus.gameOver) 
                {
                  return Positioned(
                    bottom: 50,
                    left: 50,
                    right: 50,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          gameBloc.add(RestartGameEvent()); // Restart the game
                        },
                        child: Text('Restart Game'),
                      ),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}