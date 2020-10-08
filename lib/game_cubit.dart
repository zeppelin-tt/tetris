import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris/blocks.dart';
import 'package:tetris/shape.dart';

import 'constants.dart';
import 'game_state.dart';
import 'randomizer.dart';

class GameCubit extends Cubit<GameState> {
  Shape _shape;
  Duration _duration;
  bool onPause = false;

  GameCubit(Duration initialDuration) : super(GameState({})) {
    _duration = initialDuration;
    _shape = Shape.empty();
  }

  void clearGlass() {
    final Map<int, Color> glass = {};
    for (int i = 0; i < 252; i++) {
      if (i % 12 == 0 || (i + 1) % 12 == 0 || i + 12 > 252) {
        glass[i] = Colors.white;
        continue;
      }
      glass[i] = Colors.black;
    }
    emit(GameState(glass));
  }

  void startGame() {
    if (_shape.isEmpty) {
      _shape = Randomizer.shape;
      _shapeToGlass();
    }
    Future.doWhile(() async {
      if (_moveDown()) {
        await Future.delayed(_duration);
        return !onPause;
      }
      _burningLines();
      _shape = Randomizer.shape;
      _shapeToGlass();
      await Future.delayed(_duration);
      return !onPause;
    });
  }

  void togglePause() {
    if (onPause) {
      onPause = false;
      startGame();
      return;
    }
    onPause = true;
  }

  void setDuration(Duration duration) => this._duration = duration;

  bool isGameOver() => state.glassLines.keys.any((p) => _shape.block.location.contains(p));

  void toRight() {
    final possibleBlock = block.tryMoveRight(1);
    if (_isCollision(possibleBlock.location)) {
      return;
    }
    _shape.changeLocation(possibleBlock.location);
    _shapeToGlass();
  }

  void toLeft() {
    final possibleBlock = block.tryMoveLeft(1);
    if (_isCollision(possibleBlock.location)) {
      return;
    }
    _shape.changeLocation(possibleBlock.location);
    _shapeToGlass();
  }

  void twist() {
    Block possibleBlock = block.tryTwist();
    final collisionPixels = _collisionPixels(possibleBlock.location);
    if (collisionPixels.isEmpty) {
      _shape.changeLocation(possibleBlock.location);
      _shapeToGlass();
      return;
    }
    final collisionShift = possibleBlock.collisionShift(collisionPixels);
    Block afterShiftPossibleBlock = collisionShift.isNegative
        ? possibleBlock.tryMoveLeft(collisionShift.abs())
        : possibleBlock.tryMoveRight(collisionShift);
    final afterShiftCollisionPixels = _collisionPixels(afterShiftPossibleBlock.location);
    if (afterShiftCollisionPixels.isEmpty) {
      _shape.changeLocation(afterShiftPossibleBlock.location);
      _shapeToGlass();
    }
  }

  Block get block => _shape.block;

  List<int> get currentLocation => block.location;

  List<int> get oldLocation => _shape.oldBlock.location;

  bool _isCollision(List<int> newLocation) => _collisionPixels(newLocation).isNotEmpty;

  List<int> _collisionPixels(List<int> newLocation) {
    return state.occupiedPixels.where((p) => !currentLocation.contains(p) && newLocation.contains(p)).toList();
  }

  bool _moveDown() {
    final possibleBlock = block.tryMoveDown();
    if (_isCollision(possibleBlock.location)) {
      return false;
    }
    _shape.changeLocation(possibleBlock.location);
    _shapeToGlass();
    return true;
  }

  void _burningLines() {
    final glassLines = state.glassLines;
    Map<int, Color> tempoMap = {};
    glassLines.forEach((key, value) {
      tempoMap.addAll(value);
      if (value.values.every((c) => c != Colors.black) && key != 20) {
        tempoMap = _topCollapse(tempoMap, value.keys.toList());
      }
    });
    emit(GameState(tempoMap));
  }

  void _shapeToGlass([List<int> newLocation]) {
    Map<int, Color> map = state.glass;
    for (final point in oldLocation) {
      map[point] = Colors.black;
    }
    for (final point in newLocation ?? currentLocation) {
      map[point] = _shape.color;
    }
    emit(GameState(map));
  }

  Map<int, Color> _topCollapse(Map<int, Color> pixels, List<int> burningLine) {
    Map<int, Color> map = Map.of(state.glass);
    for (final point in burningLine..addAll(pixels.keys)) {
      if (glassSides.every((i) => i != point)) {
        map[point] = Colors.black;
      }
    }
    return map..addAll(pixels.map((key, value) => MapEntry(key + 12, value)));
  }

  fastDown() {}
}
