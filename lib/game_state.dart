import 'package:flutter/material.dart';
import 'package:tetris/randomizer.dart';

import 'blocks.dart';

class GameState {
  Map<int, Color> glass;
  bool isGameOver;
  Block currentBlock;
  Block nextBlock;
  Block oldBlock;
  bool onPause;
  bool soundOn;
  int score;
  int level;

  GameState({
    this.glass,
    this.currentBlock,
    this.nextBlock,
    this.oldBlock,
    this.isGameOver = false,
    this.onPause = false,
    this.soundOn = false,
    this.score = 0,
    this.level,
  });

  List<int> get occupiedPixels {
    return glass.entries.where((e) => e.value != Colors.black).map((e) => e.key).toList();
  }

  void changeLocation(List<int> newLocation) {
    oldBlock.location = List.of(currentBlock.location);
    currentBlock.changeLocation(newLocation);
  }

  void onNextBlock(Block block) {
    currentBlock = nextBlock.copyWith();
    nextBlock = block;
  }

  Map<int, Map<int, Color>> get glassLines {
    final Map<int, Map<int, Color>> glassMap = Map.fromIterable(
      List.generate(21, (i) => i),
      key: (item) => item,
      value: (item) => <int, Color>{},
    );
    var tempoLineIndex = 0;
    glass.entries.forEach((e) {
      if (e.key >= 0) {
        if (e.key <= 251) {
          glassMap[tempoLineIndex][e.key] = e.value;
        }
        if (e.key % 12 == 11) {
          tempoLineIndex++;
        }
      }
    });
    return glassMap;
  }

  GameState copyWith({
    Map<int, Color> glass,
    bool isGameOver,
    Block currentBlock,
    Block nextBlock,
    Block oldBlock,
    bool onPause,
    bool soundOn,
    int score,
    int level,
  }) {
    return GameState(
      glass: glass ?? this.glass,
      isGameOver: isGameOver ?? this.isGameOver,
      currentBlock: currentBlock ?? this.currentBlock,
      nextBlock: nextBlock ?? this.nextBlock,
      oldBlock: oldBlock ?? this.oldBlock,
      onPause: onPause ?? this.onPause,
      soundOn: soundOn ?? this.soundOn,
      score: score ?? this.score,
      level: level ?? this.level,
    );
  }
}
