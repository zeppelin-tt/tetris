import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris/state_management/game_cubit.dart';

void gameOverDialog(BuildContext appContext, int score) {
  showDialog<void>(
    context: appContext,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Game Over'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('You scored $score points'),
              Text('Would you like to play again?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes please!'),
            onPressed: () {
              Navigator.of(context).pop();
              appContext.read<GameCubit>().newGame(1);
            },
          ),
          TextButton(
            child: Text('Exit the game'),
            onPressed: () => SystemNavigator.pop(),
          ),
        ],
      );
    },
  );
}
