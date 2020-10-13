import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tetris/blocks.dart';

import 'constants.dart';
import 'game_state.dart';
import 'randomizer.dart';

class GameCubit extends Cubit<GameState> {
  Randomizer _randomizer;
  Duration _duration;
  bool onFastHorizontalMoving = false;
  bool onFastVerticalMoving = false;
  int _initialLevel;
  Timer _timer;
  Timer _horizontalMoveTimer;

  AssetsAudioPlayer _player;

  GameCubit({
    @required int initialLevel,
  }) : super(
          GameState(
            glass: {},
            oldBlock: EmptyBlock(),
            currentBlock: EmptyBlock(),
            nextBlock: EmptyBlock(),
            level: initialLevel,
          ),
        ) {
    _randomizer = Randomizer();
    _initialLevel = initialLevel;
    _setDuration(initialLevel);
    _player = AssetsAudioPlayer.newPlayer();
  }

  void newGame([int initLevel]) {
    _setDuration(initLevel ?? _initialLevel ?? 1);
    createGlass(changeLevel: initLevel);
    startGame();
  }

  void createGlass({
    int changeLevel,
  }) {
    emit(state.copyWith(
      glass: _clearGlass,
      isGameOver: false,
      onPause: false,
      score: 0,
      level: changeLevel,
    ));
  }

  Map<int, Color> get _clearGlass {
    final Map<int, Color> glass = {};
    for (int i = -48; i < 252; i++) {
      if (i % 12 == 0 || (i + 1) % 12 == 0 || i > 240) {
        glass[i] = Colors.white;
        continue;
      }
      glass[i] = Colors.black;
    }
    return glass;
  }

  void startGame([Duration duration]) {
    if (state.currentBlock.isEmpty) {
      state.currentBlock = _randomizer.block;
      state.nextBlock = _randomizer.block;
      _shapeToGlass();
    }
    _timer = Timer.periodic(duration ?? _duration, (timer) async {
      if (_moveDown()) {
        return;
      }
      final landingResult = _landingActions();
      _landingSound(landingResult);
      if (!_gameOverCondition()) {
        state.onNextBlock(_randomizer.block);
        _addNewShape();
      }
      if (onFastVerticalMoving) {
        stopDownFastMove();
      }
    });
  }

  bool _gameOverCondition() {
    if (currentLocation.any((p) => p.isNegative)) {
      _timer.cancel();
      if (state.soundOn) {
        _player.open(Audio('assets/sounds/game_over.wav'), autoStart: true);
      }
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
    _timer.cancel();
    emit(state.copyWith(onPause: true));
  }

  void horizontalMove(GlassSide side) {
    var possibleBlock;
    switch (side) {
      case GlassSide.right:
        possibleBlock = currentBlock.tryMoveRight(1);
        break;
      case GlassSide.left:
        possibleBlock = currentBlock.tryMoveLeft(1);
        break;
    }
    if (_isCollision(possibleBlock.location)) {
      return;
    }
    state.changeLocation(possibleBlock.location);
    _shapeToGlass();
  }

  void horizontalMoveFast(GlassSide side) {
    _horizontalMoveTimer = Timer.periodic(Constants.fastHorizontalMoveDuration, (timer) => horizontalMove(side));
  }

  void stopHorizontalMove() {
    if (_horizontalMoveTimer != null && _horizontalMoveTimer.isActive) {
      _horizontalMoveTimer.cancel();
    }
  }

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

  Block get currentBlock => state.currentBlock;

  List<int> get currentLocation => currentBlock.location;

  Color get currentColor => currentBlock.color;

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
    _timer.cancel();
    startGame(Constants.fastDownMoveDuration);
  }

  void stopDownFastMove() {
    onFastVerticalMoving = false;
    _timer.cancel();
    startGame();
  }

  ResultShapeLanding _landingActions() {
    final glassLines = state.glassLines;
    var burningLines = <int>[];
    glassLines.forEach((lineIndex, Map<int, Color> lineMap) {
      if (lineMap.values.every((c) => c != Colors.black)) {
        burningLines.add(lineIndex);
      }
    });
    final tempoMap = _clearGlass;
    var shift = 0;
    for (var i = 19; i >= 0; i--) {
      if (burningLines.contains(i)) {
        shift++;
        continue;
      }
      glassLines[i].forEach((key, value) {
        tempoMap[key + 12 * shift] = value;
      });
    }
    ResultShapeLanding result = ResultShapeLanding(linesBurned: burningLines.length);
    if (burningLines.isNotEmpty) {
      state.changeLocation(currentBlock.tryMoveDown(burningLines.length).location);
      final score = state.score + Constants.scores[burningLines.length];
      final level = (score / Constants.scoresInLevel).floor() + 1;
      if (level != state.level) {
        result.levelUpgrade = true;
        _setDuration(level);
      }
      emit(state.copyWith(glass: tempoMap, score: score, level: level));
    }
    return result;
  }

  void _landingSound(ResultShapeLanding result) async {
    if (!state.soundOn) {
      return;
    }
    // await _player.open(Audio('assets/sounds/${Randomizer.layoutSound}'), autoStart: true);
    if (result.linesBurned != 0) {
      await _player.open(Audio('assets/sounds/${Constants.burningSounds[result.linesBurned]}'), autoStart: true);
    }
    if (result.levelUpgrade) {
      _player.open(Audio('assets/sounds/${_randomizer.levelUpgradeSound}'), autoStart: true);
    }
  }

  void _shapeToGlass([List<int> newLocation]) {
    Map<int, Color> map = state.glass;
    for (final point in oldLocation) {
      map[point] = Colors.black;
    }
    for (final point in newLocation ?? currentLocation) {
      map[point] = currentBlock.color;
    }
    emit(state.copyWith(glass: map));
  }

  void _addNewShape() {
    Map<int, Color> map = state.glass;
    for (final point in currentLocation) {
      map[point] = currentBlock.color;
    }
    emit(state.copyWith(glass: map));
  }

  Duration _getDuration(int level) {
    var mills = Constants.firstLevelDurationMills;
    for (var i = 1; i != level; i++) {
      mills = (mills * .87).floor();
    }
    return Duration(milliseconds: mills);
  }

  void _setDuration([int level]) => _duration = _getDuration(level ?? state.level);

  void toggleSound() => emit(state.copyWith(soundOn: !state.soundOn));
}

class ResultShapeLanding {
  int linesBurned;
  bool levelUpgrade;

  ResultShapeLanding({
    @required this.linesBurned,
    this.levelUpgrade = false,
  });

  @override
  String toString() {
    return 'ResultShapeLanding{linesBurned: $linesBurned, levelUpgrade: $levelUpgrade}';
  }
}

enum GlassSide { right, left }
