import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris/blocks.dart';
import 'package:tetris/shape.dart';

import 'constants.dart';
import 'game_state.dart';
import 'randomizer.dart';

class GameCubit extends Cubit<GameState> {
  Duration _duration;
  bool onFastHorizontalMoving = false;
  bool onFastVerticalMoving = false;
  int _initialLevel;

  GameCubit({
    @required int initialLevel,
  }) : super(GameState(
          glass: {},
          oldBlock: Block([]),
          shape: Shape.empty(),
          nextShape: Shape.empty(),
          level: initialLevel,
        )) {
    _initialLevel = initialLevel;
    _setDuration(initialLevel);
  }

  void newGame([int initLevel]) {
    _setDuration(initLevel ?? _initialLevel ?? 1);
    clearGlass(changeLevel: initLevel);
    startGame();
  }

  void clearGlass({
    int changeLevel,
  }) {
    final Map<int, Color> glass = {};
    for (int i = -48; i < 252; i++) {
      if (i % 12 == 0 || (i + 1) % 12 == 0 || i + 12 > 252) {
        glass[i] = Colors.white;
        continue;
      }
      glass[i] = Colors.black;
    }
    emit(state.copyWith(glass: glass, isGameOver: false, onPause: false, score: 0, level: changeLevel));
  }

  void startGame() {
    if (state.shape.isEmpty) {
      state.shape = Randomizer.shape;
      state.nextShape = Randomizer.shape;
      _shapeToGlass();
    }
    Future.doWhile(() async {
      if (_moveDown()) {
        await Future.delayed(_duration);
        return !state.onPause && !onFastVerticalMoving;
      }
      _burningLines();
      if (!_gameOverCondition()) {
        state.onNextShape();
        _addNewShape();
      }
      await Future.delayed(_duration);
      return !state.onPause && !onFastVerticalMoving;
    });
  }

  bool _gameOverCondition() {
    if (currentLocation.any((p) => p.isNegative)) {
      emit(state.copyWith(isGameOver: true, onPause: true));
      return true;
    }
    return false;
  }

  void togglePause() {
    if (state.onPause) {
      emit(state.copyWith(onPause: false));
      startGame();
      return;
    }
    emit(state.copyWith(onPause: true));
  }

  void toRight() {
    if (state.onPause) return;
    final possibleBlock = currentBlock.tryMoveRight(1);
    if (_isCollision(possibleBlock.location)) {
      return;
    }
    state.changeLocation(possibleBlock.location);
    _shapeToGlass();
  }

  void toRightFast() {
    onFastHorizontalMoving = true;
    Future.doWhile(() async {
      toRight();
      await Future.delayed(const Duration(milliseconds: 50));
      return onFastHorizontalMoving;
    });
  }

  void stopRightMove() => onFastHorizontalMoving = false;

  void toLeft() {
    if (state.onPause) return;
    final possibleBlock = currentBlock.tryMoveLeft(1);
    if (_isCollision(possibleBlock.location)) {
      return;
    }
    state.changeLocation(possibleBlock.location);
    _shapeToGlass();
  }

  void toLeftFast() {
    onFastHorizontalMoving = true;
    Future.doWhile(() async {
      toLeft();
      await Future.delayed(const Duration(milliseconds: 50));
      return onFastHorizontalMoving;
    });
  }

  void stopLeftMove() => onFastHorizontalMoving = false;

  void twist() {
    if (state.onPause) return;
    Block possibleBlock = currentBlock.tryTwist();
    final collisionPixels = _collisionPixels(possibleBlock.location);
    if (collisionPixels.isEmpty) {
      state.changeLocation(possibleBlock.location);
      _shapeToGlass();
      return;
    }
    final collisionShift = possibleBlock.collisionShift(collisionPixels);
    Block afterShiftPossibleBlock = collisionShift.isNegative
        ? possibleBlock.tryMoveLeft(collisionShift.abs())
        : possibleBlock.tryMoveRight(collisionShift);
    final afterShiftCollisionPixels = _collisionPixels(afterShiftPossibleBlock.location);
    if (afterShiftCollisionPixels.isEmpty) {
      state.changeLocation(afterShiftPossibleBlock.location);
      _shapeToGlass();
    }
  }

  Block get currentBlock => state.shape.block;

  List<int> get currentLocation => currentBlock.location;

  Color get currentColor => state.shape.color;

  List<int> get oldLocation => state.oldBlock.location;

  bool _isCollision(List<int> newLocation) => _collisionPixels(newLocation).isNotEmpty;

  List<int> _collisionPixels(List<int> newLocation) {
    return state.occupiedPixels.where((p) => !currentLocation.contains(p) && newLocation.contains(p)).toList();
  }

  bool _moveDown() {
    final possibleBlock = currentBlock.tryMoveDown();
    if (_isCollision(possibleBlock.location)) {
      return false;
    }
    state.changeLocation(possibleBlock.location);
    _shapeToGlass();
    return true;
  }

  void moveDown() {
    if (state.onPause) return;
    _moveDown();
  }

  void toDownFast() {
    onFastVerticalMoving = true;
    Future.doWhile(() async {
      if (_moveDown()) {
        await Future.delayed(const Duration(milliseconds: 40));
        return onFastVerticalMoving;
      }
      onFastVerticalMoving = false;
      emit(state.copyWith(onPause: false));
      startGame();
      return false;
    });
  }

  void stopDownMove() => onFastHorizontalMoving = false;

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
    if (lineCounter != 0) {
      state.changeLocation(state.shape.block.tryMoveDown(lineCounter).location);
      final score = state.score + getScore(lineCounter);
      final level = (score / scoresInLevel).floor() + 1;
      if (level != state.level) {
        _setDuration(level);
      }
      emit(state.copyWith(glass: tempoMap, score: score, level: level));
    }
  }

  int getScore(int linesCount) {
    var score;
    switch (linesCount) {
      case 1:
        score = 100;
        break;
      case 2:
        score = 300;
        break;
      case 3:
        score = 700;
        break;
      case 4:
        score = 1500;
        break;
      default:
        score = 0;
    }
    return score;
  }

  void _shapeToGlass([List<int> newLocation]) {
    Map<int, Color> map = state.glass;
    for (final point in oldLocation) {
      map[point] = Colors.black;
    }
    for (final point in newLocation ?? currentLocation) {
      map[point] = state.shape.color;
    }
    emit(state.copyWith(glass: map));
  }

  void _addNewShape() {
    Map<int, Color> map = state.glass;
    for (final point in currentLocation) {
      map[point] = state.shape.color;
    }
    emit(state.copyWith(glass: map));
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

  Duration _getDuration(int level) {
    var mills = 700;
    for (var i = 1; i != level; i++) {
      mills = (mills * .85).floor();
    }
    return Duration(milliseconds: mills);
  }

  void _setDuration([int level]) => _duration = _getDuration(level ?? state.level);
}
