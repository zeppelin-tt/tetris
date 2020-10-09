import 'package:flutter/material.dart';

class GameState {
  Map<int, Color> glass;
  bool isGameOver;

  GameState({
    @required this.glass,
    this.isGameOver = false,
  });

  List<int> get occupiedPixels {
    return glass.entries.where((e) => e.value != Colors.black).map((e) => e.key).toList();
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
  }) {
    return GameState(
      glass: glass ?? this.glass,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }

  @override
  String toString() {
    return 'GameState{glass: $glass}';
  }
}
