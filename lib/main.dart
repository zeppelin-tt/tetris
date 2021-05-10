import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/game_page.dart';
import 'state_management/game_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<GameCubit>(
        lazy: false,
        create: (context) => GameCubit(initialLevel: 1)
          ..createGlass()
          ..startGame(),
        child: const GamePage(),
      ),
    );
  }
}
