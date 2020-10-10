import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_cubit.dart';
import 'game_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GamePage(),
    );
  }
}

class GamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final width = constraints.biggest.width;
          final bottomHeight = constraints.biggest.height * .3;
          final glassHeight = constraints.biggest.height - bottomHeight;
          final buttonSize = width * .17;
          // print(bottomHeight);
          // print(glassHeight);
          final rectSize = glassHeight / 21;
          // print(rectSize);
          return BlocProvider<GameCubit>(
            lazy: false,
            create: (context) => GameCubit(initialDuration: Duration(milliseconds: 400))
              ..clearGlass()
              ..startGame(),
            child: BlocConsumer<GameCubit, GameState>(
              listener: (BuildContext context, state) {
                if (state.isGameOver) {
                  gameOverDialog(context);
                }
              },
              builder: (context, game) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: rectSize * 12,
                      height: glassHeight,
                      color: Colors.black,
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 12,
                        children: List.generate(252, (index) {
                          return game.glass[index] == Colors.white
                              ? Container(height: .0, width: .0)
                              : Center(
                                  child: Container(
                                    height: rectSize * .9,
                                    width: rectSize * .9,
                                    decoration: BoxDecoration(
                                      color: game.glass[index],
                                      borderRadius: BorderRadius.circular(rectSize * .9 * .12),
                                    ),
                                    // child: Center(child: Text(index.toString(), style: TextStyle(color: Colors.yellow))),
                                  ),
                                );
                        }),
                      ),
                    ),
                    Container(
                      height: bottomHeight,
                      child: Row(
                        children: [
                          SizedBox(width: width * .035),
                          SizedBox(
                            height: width * .325,
                            width: width * .45,
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onLongPressStart: (_) => context.bloc<GameCubit>().toLeftFast(),
                                      onLongPressEnd: (_) => context.bloc<GameCubit>().stopLeftMove(),
                                      onTap: () => context.bloc<GameCubit>().toLeft(),
                                      child: ClipOval(
                                        child: Container(
                                          height: buttonSize,
                                          width: buttonSize,
                                          color: Colors.yellow,
                                          child: Icon(Icons.chevron_left, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onLongPressStart: (_) => context.bloc<GameCubit>().toRightFast(),
                                      onLongPressEnd: (_) => context.bloc<GameCubit>().stopRightMove(),
                                      onTap: () => context.bloc<GameCubit>().toRight(),
                                      child: ClipOval(
                                        child: Container(
                                          height: buttonSize,
                                          width: buttonSize,
                                          color: Colors.yellow,
                                          child: Icon(Icons.chevron_right, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                    onLongPressStart: (_) => context.bloc<GameCubit>().toDownFast(),
                                    onLongPressEnd: (_) => context.bloc<GameCubit>().stopDownMove(),
                                    onTap: () => context.bloc<GameCubit>().moveDown(),
                                    child: ClipOval(
                                      child: Container(
                                        height: buttonSize,
                                        width: buttonSize,
                                        color: Colors.yellow,
                                        child: Center(
                                          child: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: width * .45,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: glassHeight * .11,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => context.bloc<GameCubit>().togglePause(),
                                        child: ClipOval(
                                          child: Container(
                                            height: buttonSize * 0.35,
                                            width: buttonSize * 0.35,
                                            color: Colors.blue,
                                            child: Center(
                                              child: Icon(Icons.pause, color: Colors.black, size: width * .03),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ClipOval(
                                    child: Container(
                                      height: buttonSize * 1.55,
                                      width: buttonSize * 1.55,
                                      color: Colors.yellow,
                                      child: FlatButton(
                                        color: Colors.yellow,
                                        onPressed: () => context.bloc<GameCubit>().twist(),
                                        child: Icon(Icons.autorenew, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: width * .035),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

void gameOverDialog(BuildContext appContext) {
  showDialog<void>(
    context: appContext,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Game Over'),
        content: SingleChildScrollView(
          child: Text('Would you like to play again?'),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes please!'),
            onPressed: () {
              Navigator.of(context).pop();
              appContext.bloc<GameCubit>().newGame();
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
