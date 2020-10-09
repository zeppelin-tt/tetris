import 'package:flutter/material.dart';

import 'blocks.dart';

class ShapeState {
  Block block;
  Block oldBlock;
  Color color;

  ShapeState({
    this.block,
    this.color,
    this.oldBlock,
  });

  ShapeState.empty() {
    block = EmptyBlock();
    oldBlock = EmptyBlock();
    color = Colors.black;
  }

  bool get isEmpty => block.location.isEmpty;

  bool get isNotEmpty => block.location.isNotEmpty;

  void changeLocation(List<int> newLocation) {
    oldBlock.location = List.of(block.location);
    block.changeLocation(newLocation);
  }

  ShapeState copyWith({
    Block block,
    Block oldBlock,
    Color color,
  }) => ShapeState(
        block: block ?? this.block,
        oldBlock: oldBlock ?? this.oldBlock,
        color: color ?? this.color,
      );

  @override
  String toString() => 'Shape{block: $block, oldBlock: $oldBlock, color: $color}';
}
