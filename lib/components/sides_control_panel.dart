import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris/state_management/game_cubit.dart';

import 'tetris_button.dart';

class SidesControlPanel extends StatelessWidget {
  final double height;
  final double sideWidth;
  final bool isOnPause;
  final bool isSoundOn;

  const SidesControlPanel({
    required this.height,
    required this.sideWidth,
    required this.isOnPause,
    required this.isSoundOn,
  });

  @override
  Widget build(BuildContext context) {
    final leftControlWidth = sideWidth * .68;
    final leftControlHeight = sideWidth * .566;
    final buttonSize = sideWidth * .28;
    final sizePadding = (sideWidth - leftControlWidth) / 2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: sideWidth,
              height: height * .157,
              child: Row(
                children: [
                  SizedBox(width: buttonSize * 0.25),
                  TetrisButton(
                    size: buttonSize * 0.45,
                    icon: isOnPause ? Icons.play_arrow : Icons.pause,
                    color: Colors.blue,
                    onPressColor: Colors.blue.withOpacity(.8),
                    iconSize: sideWidth * .06,
                    onTap: context.read<GameCubit>().togglePause,
                  ),
                  SizedBox(width: buttonSize * 0.25),
                  TetrisButton(
                    size: buttonSize * 0.45,
                    icon: isSoundOn ? Icons.volume_up_sharp : Icons.volume_off_outlined,
                    color: Colors.blue,
                    onPressColor: Colors.blue.withOpacity(.8),
                    iconSize: sideWidth * .06,
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
            Padding(
              padding: EdgeInsets.only(bottom: sizePadding, left: sizePadding),
              child: SizedBox(
                height: leftControlHeight,
                width: leftControlWidth,
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
                          iconSize: sideWidth * .12,
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
                          iconSize: sideWidth * .12,
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
                        iconSize: sideWidth * .12,
                        onTap: context.read<GameCubit>().moveDown,
                        onLongPressStart: (_) => context.read<GameCubit>().toDownFast(),
                        onLongPressEnd: (_) => context.read<GameCubit>().stopDownFastMove(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: sizePadding, bottom: sizePadding),
          child: SizedBox(
            width: sideWidth * .45,
            child: Padding(
              padding: EdgeInsets.only(top: buttonSize * .15),
              child: TetrisButton(
                size: buttonSize * 1.55,
                icon: Icons.autorenew,
                color: Colors.yellow,
                onPressColor: Colors.yellow.withOpacity(.8),
                iconSize: sideWidth * .12,
                onTapDown: (_) => context.read<GameCubit>().twist(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
