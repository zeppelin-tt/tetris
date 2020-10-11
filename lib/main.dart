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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
          final rectSize = glassHeight / 21;
          final sideWidth = (width - rectSize * 10.28) / 2;
          // print(bottomHeight);
          // print(glassHeight);
          // print(rectSize);
          return BlocProvider<GameCubit>(
            lazy: false,
            create: (context) => GameCubit(initialDuration: Duration(milliseconds: 400))
              ..clearGlass()
              ..startGame(),
            child: BlocConsumer<GameCubit, GameState>(
              listener: (BuildContext context, state) {
                if (state.isGameOver) {
                  gameOverDialog(context, state.score);
                }
              },
              builder: (context, game) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
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
                                          // child: Center(
                                          //   child: Text(
                                          //     index.toString(),
                                          //     style: TextStyle(color: Colors.yellow, fontSize: 11.0),
                                          //   ),
                                          // ),
                                        ),
                                      );
                              }),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: sideWidth),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              width: rectSize * 10.28,
                              height: glassHeight - rectSize * .86,
                              decoration: BoxDecoration(
                                color: game.onPause && !game.isGameOver ? Colors.black.withOpacity(.8) : Colors.transparent,
                                border: Border(
                                  left: BorderSide(color: Colors.yellow, width: 2.0),
                                  right: BorderSide(color: Colors.yellow, width: 2.0),
                                  bottom: BorderSide(color: Colors.yellow, width: 2.0),
                                ),
                              ),
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  style: game.onPause && !game.isGameOver
                                      ? TextStyle(color: Colors.yellow, fontSize: 56.0)
                                      : TextStyle(color: Colors.transparent, fontSize: 4.0),
                                  duration: Duration(milliseconds: 500),
                                  child: Text('Pause'),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(height: (sideWidth - (sideWidth * .75)) / 2),
                                Text('Score', style: TextStyle(color: Colors.yellow)),
                                SizedBox(height: (sideWidth - (sideWidth * .75)) / 2),
                                Text(game.score.toString(), style: TextStyle(color: Colors.yellow)),
                                SizedBox(height: sideWidth / 2),
                                Text('Next', style: TextStyle(color: Colors.yellow)),
                                SizedBox(
                                  width: sideWidth,
                                  height: sideWidth,
                                  child: Center(
                                    child: Container(
                                      width: sideWidth * .75,
                                      height: sideWidth * .75,
                                      child: GridView.count(
                                        shrinkWrap: true,
                                        crossAxisCount: 4,
                                        children: List.generate(16, (index) {
                                          return Center(
                                            child: Container(
                                              height: sideWidth * .75 / 4.6,
                                              width: sideWidth * .75 / 4.6,
                                              decoration: BoxDecoration(
                                                color: game.nextShape.nextLocationView[index],
                                                borderRadius: BorderRadius.circular(sideWidth * .08 / 4.6),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
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
                                              child: Icon(
                                                game.onPause ? Icons.play_arrow : Icons.pause,
                                                color: Colors.black,
                                                size: width * .04,
                                              ),
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
