import 'package:flutter/material.dart';
import 'package:tetris/blocks.dart';

class GameInfo extends StatelessWidget {
  final double sideWidth;
  final double glassHeight;
  final String score;
  final String level;
  final Block nextBlock;

  const GameInfo({
    required this.sideWidth,
    required this.glassHeight,
    required this.score,
    required this.level,
    required this.nextBlock,
  });

  @override
  Widget build(BuildContext context) {
    final nextBoxSize = glassHeight * .1;
    final nextBoxRectSize = glassHeight / 46;
    final textStyle = TextStyle(color: Colors.yellow, fontSize: glassHeight * .036);
    final verticalPadding = glassHeight * .026;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: verticalPadding),
        Text('Score', style: textStyle),
        SizedBox(height: verticalPadding),
        Text(score, style: textStyle),
        SizedBox(height: verticalPadding),
        Text('Level', style: textStyle),
        SizedBox(height: verticalPadding),
        Text(level, style: textStyle),
        SizedBox(height: verticalPadding),
        Text('Next', style: textStyle),
        SizedBox(height: verticalPadding),
        Container(
          width: nextBoxSize,
          height: nextBoxSize,
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            children: List.generate(16, (index) {
              return Center(
                child: Container(
                  height: nextBoxRectSize,
                  width: nextBoxRectSize,
                  decoration: BoxDecoration(
                    color: nextBlock.nextLocationView[index],
                    borderRadius: BorderRadius.circular(glassHeight * .005),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
