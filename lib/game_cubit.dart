import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris/blocks.dart';
import 'package:tetris/shape.dart';
import 'dart:math';

import 'constants.dart';
import 'game_state.dart';
import 'randomizer.dart';

class GameCubit extends Cubit<GameState> {
  Shape _shape;
  List<int> _surface;

  GameCubit() : super(GameState({})) {
    _shape = Shape.empty();
  }

  void clearGlass() {
    final Map<int, Color> glass = {};
    for (int i = 0; i < 200; i++) {
      glass[i] = Colors.black;
    }
    emit(GameState(glass));
  }

  void startGame() {
    _shape = Shape(block: Randomizer.block, color: Randomizer.color, oldBlock: EmptyBlock());
    _shapeToGlass();
    _surface = List.of(bottomSurface);
    const duration = Duration(milliseconds: 500);
    Timer.periodic(duration, (timer) {
      // print(_shape);
      if (_hitFloor) {
        _surface = state.getSurface();
        print('_surface: $_surface');
        _shape = Shape(block: Randomizer.block, color: Randomizer.color, oldBlock: EmptyBlock());
        print(_shape);
        _shapeToGlass();
      } else {
        _moveDown();
      }
    });
  }

  void toRight() {
    if (currentLocation.any((e) => e % 10 == 9)) {
      return;
    }
    final rightShapeSurface = block.rightSurface;
    if (state.glass.entries.where((e) => e.value != Colors.black).any((e) => rightShapeSurface.contains(e.key - 1))) {
      return;
    }
    _shape.moveRight(1);
    _shapeToGlass();
  }

  void toLeft() {
    if (currentLocation.any((e) => e % 10 == 0)) {
      return;
    }
    final leftShapeSurface = block.leftSurface;
    if (state.occupiedPixels.any((e) => leftShapeSurface.contains(e + 1))) {
      return;
    }
    _shape.moveLeft(1);
    _shapeToGlass();
  }

  void twist() {
    List<int> possibleLocation = block.tryTwist();
    final possibleLines = possibleLocation.map((e) => e % 10).toList();
    final overTheEdge = collisionLines.every(possibleLines.contains);
    final collision = _isCollision(possibleLocation);
    if (!overTheEdge && !collision) {
      _shape.changeLocation(possibleLocation);
      _shapeToGlass();
      return;
    }
    if (overTheEdge && !collision) {
      if (currentLocation.first < 5) {
        final overRightPixels = 10 - possibleLines.map((e) => e < 5 ? e + 10 : e).toList().reduce(min);
        possibleLocation = block.tryMoveRight(overRightPixels);
        if (_isCollision(possibleLocation)) {
         return;
        }
        _shapeToGlass(possibleLocation);
        return;
      } else {
        final overLeftPixels = possibleLines.map((e) => e < 5 ? e + 10 : e).toList().reduce(max) - 10;
        possibleLocation = block.tryMoveLeft(overLeftPixels);
        if (_isCollision(possibleLocation)) {
          return;
        }
        _shapeToGlass(possibleLocation);
        return;
      }
    }
    _shapeToGlass(possibleLocation);
  }

  Block get block => _shape.block;

  List<int> get currentLocation => block.location;

  List<int> get oldLocation => _shape.oldBlock.location;

  bool get _hitFloor => _surface.any((e) => currentLocation.contains(e - 10));

  bool _isCollision(List<int> newLocation) {
    return state.occupiedPixels.where((p) => !newLocation.contains(p)).any((p) => currentLocation.contains(p));
  }

  void _moveDown() {
    _shape.moveDown();
    _shapeToGlass();
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
