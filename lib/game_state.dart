import 'package:flutter/material.dart';
import 'package:tetris/constants.dart';

class GameState {
  Map<int, Color> glass;

  GameState(this.glass);

  List<int> get occupiedPixels => glass.entries.where((e) => e.value != Colors.black).map((e) => e.key).toList();

  List<int> getSurface() {
    final bottomIdleSurface = bottomSurface.where((e) => glass[e - 10] == Colors.black).toList();
    final surfaceLocations = glass.entries
        .where((e) => e.value != Colors.black && glass[e.key - 10] == Colors.black)
        .map((e) => e.key)
        .toList();
    surfaceLocations.addAll(bottomIdleSurface);
    return surfaceLocations;
  }

  @override
  String toString() {
    return 'GameState{glass: $glass}';
  }
}
