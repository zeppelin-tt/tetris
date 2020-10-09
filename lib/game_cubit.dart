import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris/blocks.dart';
import 'package:tetris/shape_state.dart';

import 'constants.dart';
import 'game_state.dart';
import 'randomizer.dart';

class GameCubit extends Cubit<GameState> {
  ShapeState _shapeState;
  Duration _duration;
  bool onPause = false;
  bool onFastMoving = false;

  GameCubit({
    @required Duration initialDuration,
  }) : super(GameState(glass: {})) {
    _duration = initialDuration;
    _shapeState = ShapeState.empty();
  }

  void newGame() {
    clearGlass();
    startGame();
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
    emit(GameState(glass: glass));
  }

  void startGame() {
    if (_shapeState.isEmpty) {
      _shapeState = Randomizer.shape;
      _shapeToGlass();
    }
    Future.doWhile(() async {
      if (_moveDown()) {
        await Future.delayed(_duration);
        return !onPause;
      }
      _burningLines();
      _gameOverCondition();
      _shapeState = Randomizer.shape;
      _shapeToGlass();
      await Future.delayed(_duration);
      return !onPause;
    });
  }

  void _gameOverCondition() {
    if (_shapeState.block.location.any((p) => p.isNegative)) {
      onPause = true;
      emit(state.copyWith(isGameOver: true));
    }
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

  void toRight() {
    if (onPause) return;
    final possibleBlock = block.tryMoveRight(1);
    if (_isCollision(possibleBlock.location)) {
      return;
    }
    _shapeState.changeLocation(possibleBlock.location);
    _shapeToGlass();
  }

  void toRightFast() {
    onFastMoving = true;
    Future.doWhile(() async {
      toRight();
      await Future.delayed(const Duration(milliseconds: 100));
      return onFastMoving;
    });
  }

  void stopRightMove() => onFastMoving = false;

  void toLeft() {
    if (onPause) return;
    final possibleBlock = block.tryMoveLeft(1);
    if (_isCollision(possibleBlock.location)) {
      return;
    }
    _shapeState.changeLocation(possibleBlock.location);
    _shapeToGlass();
  }

  void toLeftFast() {
    onFastMoving = true;
    Future.doWhile(() async {
      toLeft();
      await Future.delayed(const Duration(milliseconds: 100));
      return onFastMoving;
    });
  }

  void stopLeftMove() => onFastMoving = false;


  void twist() {
    Block possibleBlock = block.tryTwist();
    final collisionPixels = _collisionPixels(possibleBlock.location);
    if (collisionPixels.isEmpty) {
      _shapeState.changeLocation(possibleBlock.location);
      _shapeToGlass();
      return;
    }
    final collisionShift = possibleBlock.collisionShift(collisionPixels);
    Block afterShiftPossibleBlock = collisionShift.isNegative
        ? possibleBlock.tryMoveLeft(collisionShift.abs())
        : possibleBlock.tryMoveRight(collisionShift);
    final afterShiftCollisionPixels = _collisionPixels(afterShiftPossibleBlock.location);
    if (afterShiftCollisionPixels.isEmpty) {
      _shapeState.changeLocation(afterShiftPossibleBlock.location);
      _shapeToGlass();
    }
  }

  Block get block => _shapeState.block;

  List<int> get currentLocation => block.location;

  List<int> get oldLocation => _shapeState.oldBlock.location;

  bool _isCollision(List<int> newLocation) => _collisionPixels(newLocation).isNotEmpty;

  List<int> _collisionPixels(List<int> newLocation) {
    return state.occupiedPixels.where((p) => !currentLocation.contains(p) && newLocation.contains(p)).toList();
  }

  bool _moveDown() {
    final possibleBlock = block.tryMoveDown();
    if (_isCollision(possibleBlock.location)) {
      return false;
    }
    _shapeState.changeLocation(possibleBlock.location);
    _shapeToGlass();
    return true;
  }

  void _burningLines() {
    final glassLines = state.glassLines;
    Map<int, Color> tempoMap = {};
    var lineCounter = 0;
    glassLines.forEach((key, value) {
      tempoMap.addAll(value);
      if (value.values.every((c) => c != Colors.black) && key != 20) {
        tempoMap = _topCollapse(tempoMap, value.keys.toList());
        lineCounter++;
      }
    });
    _shapeState.changeLocation(_shapeState.block.tryMoveDown(lineCounter).location);
    emit(GameState(glass: tempoMap));
  }

  void _shapeToGlass([List<int> newLocation]) {
    Map<int, Color> map = state.glass;
    for (final point in oldLocation) {
      map[point] = Colors.black;
    }
    for (final point in newLocation ?? currentLocation) {
      map[point] = _shapeState.color;
    }
    emit(GameState(glass: map));
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
