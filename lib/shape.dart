import 'package:flutter/material.dart';

import 'blocks.dart';

class Shape {
  Block block;
  Block oldBlock;
  Color color;

  Shape({
    this.block,
    this.color,
    this.oldBlock,
  });

  Shape.empty() {
    block = EmptyBlock();
    oldBlock = EmptyBlock();
    color = Colors.black;
  }

  bool get isEmpty => block.location.isEmpty;

  bool get isMotEmpty => block.location.isNotEmpty;

  void moveDown() {
    oldBlock.location = List.of(block.location);
    block.moveDown();
  }

  void moveRight(int pixels) {
    oldBlock.location = List.of(block.location);
    block.moveRight(pixels);
  }

  void moveLeft(int pixels) {
    oldBlock.location = List.of(block.location);
    block.moveLeft(pixels);
  }


  void changeLocation(List<int> newLocation) {
    oldBlock.location = List.of(block.location);
    block.changeLocation(newLocation);
  }

  Shape copyWith({
    Block block,
    Block oldBlock,
    Color color,
  }) => Shape(
        block: block ?? this.block,
        oldBlock: oldBlock ?? this.oldBlock,
        color: color ?? this.color,
      );

  @override
  String toString() => 'Shape{block: $block, oldBlock: $oldBlock, color: $color}';
}
