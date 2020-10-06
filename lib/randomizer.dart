import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/shape.dart';

import 'blocks.dart';

class Randomizer {
  static final _rnd = Random();

  static final startBlocks = <Block>[
    Smashboy([-14, -13, -4, -3]),
    OrangeRicky([-24, -23, -13, -3]),
    OrangeRicky([-15, -14, -13, -5]),
    OrangeRicky([-15, -7, -6, -5]),
    OrangeRicky([-26, -16, -6, -5]),
    BlueRicky([-24, -23, -14, -4]),
    BlueRicky([-16, -6, -5, -4]),
    BlueRicky([-25, -15, -6, -5]),
    BlueRicky([-15, -14, -13, -3]),
    RhodeIsland([-16, -15, -7, -6]),
    RhodeIsland([-26, -16, -15, -5]),
    Cleveland([-16, -15, -5, -4]),
    Cleveland([-24, -15, -14, -5]),
    HeroBlock([-7, -6, -5, -4]),
    HeroBlock([-35, -25, -15, -5]),
    Teewee([-16, -15, -14, -5]),
    Teewee([-25, -16, -15, -5]),
    Teewee([-15, -6, -5, -4]),
    Teewee([-26, -16, -15, -6]),
  ];

  static const colorList = [
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.greenAccent,
    Colors.brown,
    Colors.amber,
    Colors.yellowAccent,
    Colors.indigoAccent,
    Colors.lightBlue,
  ];

  static Color get color => colorList[_rnd.nextInt(colorList.length)];

  static Block get block => startBlocks[_rnd.nextInt(startBlocks.length)];

  // static Shape get shape => Shape(block, color);
}
