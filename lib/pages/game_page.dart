import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris/components/bottom_control_panel.dart';
import 'package:tetris/components/game_info.dart';
import 'package:tetris/components/game_over_dialog.dart';
import 'package:tetris/components/glass_content.dart';
import 'package:tetris/components/pause_layer.dart';
import 'package:tetris/components/sides_control_panel.dart';
import 'package:tetris/state_management/game_cubit.dart';
import 'package:tetris/state_management/game_state.dart';
import 'package:universal_io/io.dart';

class GamePage extends StatefulWidget {
  const GamePage();

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Platform.isIOS || Platform.isAndroid || Platform.isFuchsia;
    FocusScope.of(context).requestFocus(focusNode);
    return RawKeyboardListener(
      onKey: context.read<GameCubit>().onKeyboardEvent,
      focusNode: focusNode,
      child: Material(
        color: Colors.black,
        child: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            final _width = constraints.biggest.width;
            final _height = constraints.biggest.height;
            final _ratio = _width / _height;
            final isPortrait = _ratio < .803;
            final width = _width;
            final bottomHeight = _height * .3;
            final glassHeight = isMobile && isPortrait ? (_height - bottomHeight) : _height;
            final buttonSize = width * .17;
            final rectSize = glassHeight / 21;
            final sideWidth = (width - rectSize * 10.28) / 2;
            // print(bottomHeight);
            // print(glassHeight);
            // print(rectSize);
            return BlocConsumer<GameCubit, GameState>(
              listener: (BuildContext context, state) {
                if (state.isGameOver) {
                  HapticFeedback.heavyImpact();
                  gameOverDialog(context, state.score);
                }
              },
              builder: (context, game) {
                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: GlassContent(
                        glass: game.glass!,
                        glassHeight: glassHeight,
                        rectSize: rectSize,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: sideWidth),
                        GlassOverlay(
                          glassHeight: glassHeight,
                          pauseEnable: game.onPause && !game.isGameOver,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: glassHeight * .026),
                          child: GameInfo(
                            glassHeight: glassHeight,
                            level: game.level.toString(),
                            score: game.score.toString(),
                            nextBlock: game.nextBlock!,
                            sideWidth: sideWidth,
                          ),
                        ),
                      ],
                    ),
                    if (isMobile)
                      isPortrait
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: BottomControlPanel(
                                height: bottomHeight,
                                width: width,
                                buttonSize: buttonSize,
                                isOnPause: game.onPause,
                                isSoundOn: game.soundOn,
                              ),
                            )
                          : SidesControlPanel(
                              height: _height,
                              sideWidth: sideWidth,
                              isOnPause: game.onPause,
                              isSoundOn: game.soundOn,
                            ),
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }
}
