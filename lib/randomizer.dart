import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/shape.dart';

import 'blocks.dart';

class Randomizer {
  static final _rnd = Random();

  static final startBlocks = <Block>[
    Smashboy([-19, -18, -7, -6]),
    OrangeRicky([-31, -19, -7, -6]),
    OrangeRicky([-31, -30, -18, -6]),
    OrangeRicky([-18, -8, -7, -6]),
    OrangeRicky([-20, -19, -18, -8]),
    BlueRicky([-7, -6, -18, -30]),
    BlueRicky([-20, -8, -7, -6]),
    BlueRicky([-7, -19, -31, -30]),
    BlueRicky([-6, -18, -19, -20]),
    RhodeIsland([-8, -7, -19, -18]),
    RhodeIsland([-6, -18, -19, -31]),
    Cleveland([-6, -7, -19, -20]),
    Cleveland([-7, -19, -18, -30]),
    HeroBlock([-8, -7, -6, -5]),
    HeroBlock([-7, -19, -31, -43]),
    Teewee([-8, -7, -6, -19]),
    Teewee([-7, -19, -31, -18]),
    Teewee([-6, -18, -30, -19]),
    Teewee([-20, -19, -18, -7]),
  ];

  static const colorList = [
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.greenAccent,
    Colors.amber,
    Colors.yellowAccent,
    Colors.indigoAccent,
    Colors.lightBlue,
  ];

  static Color get color => colorList[_rnd.nextInt(colorList.length)];

  static Block get block => startBlocks[_rnd.nextInt(startBlocks.length)].copyWith();

  static Shape get shape => Shape(block: block, color: color, oldBlock: EmptyBlock());
}
