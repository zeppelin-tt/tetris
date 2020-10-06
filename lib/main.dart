import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris/game_state.dart';

import 'game_cubit.dart';

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
          final bottomHeight = constraints.biggest.height * .2;
          final glassHeight = constraints.biggest.height - bottomHeight;
          // print(bottomHeight);
          // print(glassHeight);
          final rectSize = glassHeight / 21;
          // print(rectSize);
          return BlocProvider<GameCubit>(
            create: (context) => GameCubit()
              ..clearGlass()
              ..startGame(),
            child: BlocBuilder<GameCubit, GameState>(builder: (context, game) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: rectSize * 12,
                    height: glassHeight,
                    color: Colors.blueGrey,
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 12,
                      children: List.generate(252, (index) {
                        return game.glass[index] == Colors.white
                            ? Container()
                            : Center(
                                child: Container(
                                  height: rectSize * .9,
                                  width: rectSize * .9,
                                  decoration: BoxDecoration(
                                    color: game.glass[index],
                                    borderRadius: BorderRadius.circular(rectSize * .9 * .12),
                                  ),
                                  child: Center(child: Text(index.toString(), style: TextStyle(color: Colors.yellow))),
                                ),
                              );
                      }),
                    ),
                  ),
                  Container(
                    height: bottomHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50.0,
                          width: 50.0,
                          color: Colors.yellow,
                          child: FlatButton(
                            color: Colors.yellow,
                            onPressed: () => context.bloc<GameCubit>().toLeft(),
                            child: Icon(Icons.chevron_left, color: Colors.black),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          width: 50.0,
                          color: Colors.yellow,
                          child: FlatButton(
                            color: Colors.yellow,
                            onPressed: () => context.bloc<GameCubit>().fastDown(),
                            child: Icon(Icons.arrow_drop_down_sharp, color: Colors.black),
                          ),
                        ),
                        Container(
                          height: 50.0,
                          width: 50.0,
                          color: Colors.yellow,
                          child: FlatButton(
                            color: Colors.yellow,
                            onPressed: () => context.bloc<GameCubit>().toRight(),
                            child: Icon(Icons.chevron_right, color: Colors.black),
                          ),
                        ),
                        ClipOval(
                          child: Container(
                            height: 75.0,
                            width: 75.0,
                            color: Colors.yellow,
                            child: FlatButton(
                              color: Colors.yellow,
                              onPressed: () => context.bloc<GameCubit>().twist(),
                              child: Icon(Icons.autorenew, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }),
          );
        }),
      ),
    );
  }
}
