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
  bool onFastMoving = false;

  GameCubit({
    @required Duration initialDuration,
  }) : super(GameState(glass: {}, oldBlock: Block([]), shape: Shape.empty(), nextShape: Shape.empty())) {
    _duration = initialDuration;
  }

  void newGame() {
    clearGlass();
    startGame();
  }

  void clearGlass() {
    final Map<int, Color> glass = {};
    for (int i = -48; i < 252; i++) {
      if (i % 12 == 0 || (i + 1) % 12 == 0 || i + 12 > 252) {
        glass[i] = Colors.white;
        continue;
      }
      glass[i] = Colors.black;
    }
    emit(state.copyWith(glass: glass, isGameOver: false, onPause: false));
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
        return !state.onPause;
      }
      _burningLines();
      if (!_gameOverCondition()) {
        state.onNextShape();
        _addNewShape();
      }
      await Future.delayed(_duration);
      return !state.onPause;
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

  void setDuration(Duration duration) => this._duration = duration;

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
    onFastMoving = true;
    Future.doWhile(() async {
      toRight();
      await Future.delayed(const Duration(milliseconds: 100));
      return onFastMoving;
    });
  }

  void stopRightMove() => onFastMoving = false;

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
    onFastMoving = true;
    Future.doWhile(() async {
      toLeft();
      await Future.delayed(const Duration(milliseconds: 100));
      return onFastMoving;
    });
  }

  void stopLeftMove() => onFastMoving = false;


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
    emit(state.copyWith(onPause: true));
    onFastMoving = true;
    Future.doWhile(() async {
      if (_moveDown()) {
        await Future.delayed(const Duration(milliseconds: 60));
        return onFastMoving;
      }
      onFastMoving = false;
      emit(state.copyWith(onPause: false));
      startGame();
      return false;
    });
  }

  void stopDownMove() => onFastMoving = false;

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
    state.changeLocation(state.shape.block.tryMoveDown(lineCounter).location);
    emit(state.copyWith(glass: tempoMap));
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
}
