import 'package:flutter/material.dart';

import 'blocks.dart';

class Shape {
  Block block;
  Color color;

  Shape({
    this.block,
    this.color,
  });

  Shape.empty() {
    block = EmptyBlock();
    color = Colors.black;
  }

  bool get isEmpty => block.location.isEmpty;

  bool get isNotEmpty => block.location.isNotEmpty;

  Map<int, Color> get nextLocationView {
    final nextLocation = block.location.map((p) => p + 44).map((p) => p - (p / 12).floor() * 8).toList();
    return Map.fromIterable(
      List.generate(16, (i) => i),
      key: (i) => i,
      value: (i) => nextLocation.contains(i) ? color : Colors.black,
    );
  }

  Shape copyWith({
    Block block,
    Color color,
  }) {
    return Shape(
      block: block ?? this.block,
      color: color ?? this.color,
    );
  }

  @override
  String toString() => 'Shape{block: $block, color: $color}';
}
