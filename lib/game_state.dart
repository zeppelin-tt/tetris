import 'package:flutter/material.dart';
import 'package:tetris/randomizer.dart';
import 'package:tetris/shape.dart';

import 'blocks.dart';

class GameState {
  Map<int, Color> glass;
  bool isGameOver;
  Shape shape;
  Shape nextShape;
  Block oldBlock;

  GameState({
    this.glass,
    this.shape,
    this.nextShape,
    this.oldBlock,
    this.isGameOver = false,
  });

  List<int> get occupiedPixels {
    return glass.entries.where((e) => e.value != Colors.black).map((e) => e.key).toList();
  }

  void changeLocation(List<int> newLocation) {
    oldBlock.location = List.of(shape.block.location);
    shape.block.changeLocation(newLocation);
  }

  void onNextShape() {
    shape = nextShape.copyWith();
    nextShape = Randomizer.shape;
  }

  Map<int, Map<int, Color>> get glassLines {
    final Map<int, Map<int, Color>> glassMap = Map.fromIterable(
      List.generate(21, (i) => i),
      key: (item) => item,
      value: (item) => <int, Color>{},
    );
    var tempoLineIndex = 0;
    glass.entries.forEach((e) {
      if (e.key >= 0 && e.key <= 251) {
        glassMap[tempoLineIndex][e.key] = e.value;
      }
      if (e.key % 12 == 11) {
        tempoLineIndex++;
      }
    });
    return glassMap;
  }

  GameState copyWith({
    Map<int, Color> glass,
    bool isGameOver,
    Shape shape,
    Shape nextShape,
    Block oldBlock,
  }) {
    return GameState(
      glass: glass ?? this.glass,
      isGameOver: isGameOver ?? this.isGameOver,
      shape: shape ?? this.shape,
      nextShape: nextShape ?? this.nextShape,
      oldBlock: oldBlock ?? this.oldBlock,
    );
  }

  @override
  String toString() {
    return 'GameState{glass: $glass}';
  }
}
