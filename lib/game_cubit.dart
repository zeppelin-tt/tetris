import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris/blocks.dart';
import 'package:tetris/shape.dart';

import 'game_state.dart';
import 'randomizer.dart';

class GameCubit extends Cubit<GameState> {
  Shape _shape;

  GameCubit() : super(GameState({})) {
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
    _shape = Shape(block: Randomizer.block, color: Randomizer.color, oldBlock: EmptyBlock());
    _shapeToGlass();
    const duration = Duration(milliseconds: 1000);
    Timer.periodic(duration, (timer) {
      if (_moveDown()) {
        return;
      }
      _shape = Randomizer.shape;
      print(_shape);
      _shapeToGlass();
    });
  }

  void toRight() {
    final possibleLocation = block.tryMoveRight(1);
    if (_isCollision(possibleLocation)) {
      return;
    }
    _shape.changeLocation(possibleLocation);
    _shapeToGlass();
  }

  void toLeft() {
    final possibleLocation = block.tryMoveLeft(1);
    if (_isCollision(possibleLocation)) {
      return;
    }
    _shape.changeLocation(possibleLocation);
    _shapeToGlass();
  }

  void twist() {
    List<int> possibleLocation = block.tryTwist();
    // final possibleLines = possibleLocation.map((e) => e % 12).toList();
    final collision = _isCollision(possibleLocation);
    if (!collision) {
      _shape.changeLocation(possibleLocation);
      _shapeToGlass();
      return;
    }
    // if (currentLocation.first < 5) {
    //   final overRightPixels = 10 - possibleLines.map((e) => e < 5 ? e + 10 : e).toList().reduce(min);
    //   possibleLocation = block.tryMoveRight(overRightPixels);
    //   if (_isCollision(possibleLocation)) {
    //     return;
    //   }
    //   _shapeToGlass(possibleLocation);
    //   return;
    // } else {
    //   final overLeftPixels = possibleLines.map((e) => e < 5 ? e + 10 : e).toList().reduce(max) - 10;
    //   possibleLocation = block.tryMoveLeft(overLeftPixels);
    //   if (_isCollision(possibleLocation)) {
    //     return;
    //   }
    //   _shapeToGlass(possibleLocation);
    //   return;
    // }
    // _shapeToGlass(possibleLocation);
  }

  Block get block => _shape.block;

  List<int> get currentLocation => block.location;

  List<int> get oldLocation => _shape.oldBlock.location;

  bool _isCollision(List<int> newLocation) {
    return state.occupiedPixels.where((p) => !currentLocation.contains(p)).any((p) => newLocation.contains(p));
  }

  bool _moveDown() {
    final possibleLocation = block.tryMoveDown();
    if (_isCollision(possibleLocation)) {
      return false;
    }
    _shape.changeLocation(possibleLocation);
    _shapeToGlass();
    return true;
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

  fastDown() {}
}
