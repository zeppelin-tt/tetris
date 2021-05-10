import 'dart:math';

import 'blocks.dart';
import 'constants.dart';

class Randomizer {
  final _rnd = Random();
  late Map<int, BlockType> pool;
  late Map<BlockType, int> counters;

  Randomizer() {
    initPoolAndCounters();
  }

  void initPoolAndCounters() {
    final list = BlockType.values.expand((b) => List.generate(7, (_) => b)).toList();
    var counter = 0;
    pool = {for (var i in list) counter++: i};
    counters = {for (var i in BlockType.values) i: 0};
  }

  void increaseCounter(BlockType currentType) {
    for (final type in BlockType.values) {
      final newCount = counters[type]! + 1;
      counters[type] = currentType == type ? 0 : newCount;
    }
  }

  BlockType get maxAntiquityType {
    return counters.entries.reduce((curr, next) => curr.value > next.value ? curr : next).key;
  }

  Block? get block {
    Block? block;
    final blockIndex = _rnd.nextInt(pool.length);
    final blockType = pool[blockIndex]!;
    switch (blockType) {
      case BlockType.smashboy:
        block = Smashboy(Smashboy.initStates.first);
        break;
      case BlockType.orange_ricky:
        block = OrangeRicky(OrangeRicky.initStates[_rnd.nextInt(OrangeRicky.initStates.length)]);
        break;
      case BlockType.blue_ricky:
        block = BlueRicky(BlueRicky.initStates[_rnd.nextInt(BlueRicky.initStates.length)]);
        break;
      case BlockType.rhode_island:
        block = RhodeIsland(RhodeIsland.initStates[_rnd.nextInt(RhodeIsland.initStates.length)]);
        break;
      case BlockType.cleveland:
        block = Cleveland(Cleveland.initStates[_rnd.nextInt(Cleveland.initStates.length)]);
        break;
      case BlockType.hero_block:
        block = HeroBlock(HeroBlock.initStates[_rnd.nextInt(HeroBlock.initStates.length)]);
        break;
      case BlockType.teewee:
        block = Teewee(Teewee.initStates[_rnd.nextInt(Teewee.initStates.length)]);
        break;
      default:
        block = Teewee(Teewee.initStates[_rnd.nextInt(Teewee.initStates.length)]);
    }
    pool[blockIndex] = maxAntiquityType;
    increaseCounter(blockType);
    print(counters);
    return block;
  }

  String get levelUpgradeSound {
    return Constants.levelUpgradeSounds[_rnd.nextInt(Constants.levelUpgradeSounds.length)];
  }

  String get layoutSound => Constants.layoutSounds[_rnd.nextInt(Constants.layoutSounds.length)];
}

enum BlockType { smashboy, orange_ricky, blue_ricky, rhode_island, cleveland, hero_block, teewee }
