import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris/shape.dart';

import 'blocks.dart';

class Randomizer {
  static final _rnd = Random();

  static const colorList = [
    Colors.red,
    Colors.orange,
    Colors.green,
    Colors.yellow,
    Colors.indigo,
    Colors.blue,
  ];

  static Shape get shape {
    Block block;
    final blocks = Blocks.values;
    switch (blocks[_rnd.nextInt(Blocks.values.length)]) {
      case Blocks.smashboy:
        block = Smashboy(Smashboy.initStates.first);
        break;
      case Blocks.orange_ricky:
        block = OrangeRicky(OrangeRicky.initStates[_rnd.nextInt(OrangeRicky.initStates.length)]);
        break;
      case Blocks.blue_ricky:
        block = BlueRicky(BlueRicky.initStates[_rnd.nextInt(BlueRicky.initStates.length)]);
        break;
      case Blocks.rhode_island:
        block = RhodeIsland(RhodeIsland.initStates[_rnd.nextInt(RhodeIsland.initStates.length)]);
        break;
      case Blocks.cleveland:
        block = Cleveland(Cleveland.initStates[_rnd.nextInt(Cleveland.initStates.length)]);
        break;
      case Blocks.hero_block:
        block = HeroBlock(HeroBlock.initStates[_rnd.nextInt(HeroBlock.initStates.length)]);
        break;
      case Blocks.teewee:
        block = Teewee(Teewee.initStates[_rnd.nextInt(Teewee.initStates.length)]);
        break;
    }
    return Shape(block: block, color: color);
  }

  static Color get color => colorList[_rnd.nextInt(colorList.length)];
}

enum Blocks { smashboy, orange_ricky, blue_ricky, rhode_island, cleveland, hero_block, teewee }
