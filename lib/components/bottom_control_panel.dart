import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris/state_management/game_cubit.dart';

import 'tetris_button.dart';

class BottomControlPanel extends StatelessWidget {
  final double height;
  final double width;
  final double buttonSize;
  final bool isOnPause;
  final bool isSoundOn;

  const BottomControlPanel({
    required this.height,
    required this.width,
    required this.buttonSize,
    required this.isOnPause,
    required this.isSoundOn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
                    TetrisButton(
                      size: buttonSize,
                      icon: Icons.chevron_left,
                      color: Colors.yellow,
                      onPressColor: Colors.yellow.withOpacity(.8),
                      iconSize: width * .06,
                      onTap: () => context.read<GameCubit>().horizontalMove(GlassSide.left),
                      onLongPressStart: (_) {
                        context.read<GameCubit>().horizontalMoveFast(GlassSide.left);
                      },
                      onLongPressEnd: (_) => context.read<GameCubit>().stopHorizontalMove(),
                    ),
                    TetrisButton(
                      size: buttonSize,
                      icon: Icons.chevron_right,
                      color: Colors.yellow,
                      onPressColor: Colors.yellow.withOpacity(.8),
                      iconSize: width * .06,
                      onTap: () => context.read<GameCubit>().horizontalMove(GlassSide.right),
                      onLongPressStart: (_) {
                        context.read<GameCubit>().horizontalMoveFast(GlassSide.right);
                      },
                      onLongPressEnd: (_) => context.read<GameCubit>().stopHorizontalMove(),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TetrisButton(
                    size: buttonSize,
                    icon: Icons.keyboard_arrow_down,
                    color: Colors.yellow,
                    onPressColor: Colors.yellow.withOpacity(.8),
                    iconSize: width * .06,
                    onTap: context.read<GameCubit>().moveDown,
                    onLongPressStart: (_) => context.read<GameCubit>().toDownFast(),
                    onLongPressEnd: (_) => context.read<GameCubit>().stopDownFastMove(),
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
                  height: height * .257,
                  child: Row(
                    children: [
                      TetrisButton(
                        size: buttonSize * 0.45,
                        icon: isOnPause ? Icons.play_arrow : Icons.pause,
                        color: Colors.blue,
                        onPressColor: Colors.blue.withOpacity(.8),
                        iconSize: width * .06,
                        onTap: context.read<GameCubit>().togglePause,
                      ),
                      SizedBox(width: buttonSize * 0.25),
                      TetrisButton(
                        size: buttonSize * 0.45,
                        icon: isSoundOn ? Icons.volume_up_sharp : Icons.volume_off_outlined,
                        color: Colors.blue,
                        onPressColor: Colors.blue.withOpacity(.8),
                        iconSize: width * .06,
                        onTap: context.read<GameCubit>().toggleSound,
                      ),
                      SizedBox(width: buttonSize * 0.25),
                      // TetrisButton(
                      //   size: buttonSize * 0.45,
                      //   icon: Icons.settings,
                      //   color: Colors.blue,
                      //   onPressColor: Colors.blue.withOpacity(.8),
                      //   iconSize: width * .06,
                      //   onTap: () => context.bloc<GameCubit>().toggleSound(),
                      // ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: buttonSize * .15),
                    child: TetrisButton(
                      size: buttonSize * 1.55,
                      icon: Icons.autorenew,
                      color: Colors.yellow,
                      onPressColor: Colors.yellow.withOpacity(.8),
                      iconSize: 25.0,
                      onTapDown: (_) => context.read<GameCubit>().twist(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: width * .035),
        ],
      ),
    );
  }
}
