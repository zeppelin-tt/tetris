import 'package:flutter/material.dart';

class GameState {
  Map<int, Color> glass;

  GameState(this.glass);

  List<int> get occupiedPixels {
    return glass.entries.where((e) => e.value != Colors.black).map((e) => e.key).toList();
  }

  @override
  String toString() {
    return 'GameState{glass: $glass}';
  }
}
