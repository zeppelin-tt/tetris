import 'package:tetris/randomizer.dart';

class Block {
  List<int> location;

  Block(this.location);

  Block tryTwist() => copyWith(location: location);

  Block tryMoveRight(int pixels) => copyWith(location: List.of(location.map((i) => i + pixels)));

  Block tryMoveDown() => copyWith(location: List.of(location.map((i) => i + 12)));

  Block tryMoveLeft(int pixels) => copyWith(location: List.of(location.map((i) => i - pixels)));

  void changeLocation(List<int> newLocation) => location = List.of(newLocation);

  Block copyWith({
    List<int> location,
  }) =>
      Block(location ?? this.location);

  @override
  String toString() {
    return 'Block{location: $location}';
  }

  int collisionShift(List<int> collisionPixels) {
    List<int> lines = location.map((p) => p % 12).toSet().toList();
    List<int> collisionLines = collisionPixels.map((p) => p % 12).toSet().toList();
    lines.sort();
    if (const [0, 11].every((i) => lines.contains(i))) {
      final firstHalf = lines.where((i) => i < 6);
      final secondHalf = lines.where((i) => i > 5);
      final shiftedCollisionLine = <int>[];
      lines = lines.map<int>((l) {
        var newLine;
        if (secondHalf.contains(l)) {
          newLine = (secondHalf.length > firstHalf.length ? l - firstHalf.length : l - 11).abs();
        } else {
          newLine = secondHalf.length > firstHalf.length ? l + 11 : l + secondHalf.length;
        }
        if (collisionLines.contains(l)) {
          shiftedCollisionLine.add(newLine);
        }
        return newLine;
      }).toList();
      collisionLines = shiftedCollisionLine;
      lines.sort();
    }
    final collisionDistribution = lines.map((p) => collisionLines.contains(p)).toList();
    var leftPartCollisionCounter = .0;
    for (var i = 0; i < (collisionDistribution.length / 2).round(); i++) {
      if (collisionDistribution[i]) {
        leftPartCollisionCounter++;
      }
    }
    if (collisionDistribution.length.isOdd && collisionDistribution[(collisionDistribution.length / 2).floor()]) {
      leftPartCollisionCounter += .5;
    }
    if (leftPartCollisionCounter > collisionLines.length / 2) {
      for (var i = collisionDistribution.length - 1; i >= 0; i--) {
        if (collisionDistribution[i]) {
          return i + 1;
        }
      }
    } else {
      for (var i = 0; i < collisionDistribution.length; i++) {
        if (collisionDistribution[i]) {
          return i - collisionDistribution.length;
        }
      }
    }
    return collisionDistribution.length;
  }
}

class EmptyBlock extends Block {
  EmptyBlock() : super([]);

  @override
  EmptyBlock copyWith({
    List<int> location,
  }) =>
      EmptyBlock();
}

class HeroBlock extends Block {
  HeroBlock(List<int> locations) : super(locations);

  static const initStates = [
    [-8, -7, -6, -5],
    [-7, -19, -31, -43],
  ];

  @override
  Block tryTwist() {
    location.sort();
    if (location.first + 1 == location[1]) {
      return copyWith(location: [location[0] + 26, location[1] + 13, location[2], location[3] - 13]);
    } else {
      return copyWith(location: [location[3] - 26, location[2] - 13, location[1], location[0] + 13]);
    }
  }

  @override
  HeroBlock copyWith({
    List<int> location,
  }) =>
      HeroBlock(location ?? this.location);
}

class Smashboy extends Block {
  Smashboy(List<int> locations) : super(locations);

  static const initStates = [
    [-19, -18, -7, -6],
  ];

  @override
  Smashboy copyWith({
    List<int> location,
  }) {
    return Smashboy(location ?? this.location);
  }
}

class Teewee extends Block {
  Teewee(List<int> locations) : super(locations);

  static const initStates = [
    [-8, -7, -6, -19],
    [-7, -19, -31, -18],
    [-6, -18, -30, -19],
    [-20, -19, -18, -7],
  ];

  @override
  Block tryTwist() {

    location.sort();
    if (location.first + 1 == location[1]) {
      return copyWith(location: [location[0], location[1], location[2] - 13, location[3]]);
    } else if (location.last - 12 == location[2]) {
      return copyWith(location: [location[0], location[1], location[2], location[3] - 11]);
    } else if (location.last - 1 == location[2]) {
      return copyWith(location: [location[0], location[1] + 13, location[2], location[3]]);
    } else {
      return copyWith(location: [location[0] + 11, location[1], location[2], location[3]]);
    }
  }

  @override
  Teewee copyWith({
    List<int> location,
  }) {
    return Teewee(location ?? this.location);
  }
}

class RhodeIsland extends Block {
  RhodeIsland(List<int> locations) : super(locations);

  static const initStates = [
    [-8, -7, -19, -18],
    [-6, -18, -19, -31],
  ];

  @override
  Block tryTwist() {
    location.sort();
    if (location.first + 1 == location[1]) {
      return copyWith(location: [location[0], location[1], location[2] + 2, location[3] - 24]);
    } else {
      return copyWith(location: [location[0] + 24, location[1], location[2], location[3] - 2]);
    }
  }

  @override
  RhodeIsland copyWith({
    List<int> location,
  }) {
    return RhodeIsland(location ?? this.location);
  }
}

class Cleveland extends Block {
  Cleveland(List<int> locations) : super(locations);

  static const initStates = [
    [-6, -7, -19, -20],
    [-7, -19, -18, -30],
  ];

  @override
  Block tryTwist() {
    location.sort();
    if (location.first + 1 == location[1]) {
      return copyWith(location: [location[0], location[1], location[2] - 24, location[3] - 2]);
    } else {
      return copyWith(location: [location[0] + 24, location[1], location[2], location[3] + 2]);
    }
  }

  @override
  Cleveland copyWith({
    List<int> location,
  }) {
    return Cleveland(location ?? this.location);
  }
}

class OrangeRicky extends Block {
  OrangeRicky(List<int> locations) : super(locations);

  static const initStates = [
    [-31, -19, -7, -6],
    [-31, -30, -18, -6],
    [-18, -8, -7, -6],
    [-20, -19, -18, -8],
  ];

  @override
  Block tryTwist() {
    location.sort();
    if (location.first + 10 == location[1]) {
      return copyWith(location: [location[0] + 24, location[1] - 11, location[2], location[3] + 11]);
    } else if (location[1] + 13 == location.last) {
      return copyWith(location: [location[0] + 13, location[1], location[2] - 13, location[3] - 2]);
    } else if (location[2] + 10 == location.last) {
      return copyWith(location: [location[0] - 11, location[1], location[2] + 11, location[3] - 24]);
    } else {
      return copyWith(location: [location[0] + 2, location[1] + 13, location[2], location[3] - 13]);
    }
  }

  @override
  OrangeRicky copyWith({
    List<int> location,
  }) {
    return OrangeRicky(location ?? this.location);
  }
}

class BlueRicky extends Block {
  BlueRicky(List<int> locations) : super(locations);

  static const initStates = [
    [-7, -6, -18, -30],
    [-20, -8, -7, -6],
    [-7, -19, -31, -30],
    [-6, -18, -19, -20],
  ];

  @override
  Block tryTwist() {
    location.sort();
    if (location.first + 2 == location[2]) {
      return copyWith(location: [location[0] - 11, location[1], location[2] + 10, location[3] - 1]);
    } else if (location.first + 23 == location[2]) {
      return copyWith(location: [location[0] + 13, location[1], location[2] - 24, location[3] - 13]);
    } else if (location.first + 13 == location[2]) {
      return copyWith(location: [location[0] + 2, location[1] - 11, location[2], location[3] + 11]);
    } else {
      return copyWith(location: [location[0] + 13, location[1] + 24, location[2], location[3] - 13]);
    }
  }

  @override
  BlueRicky copyWith({
    List<int> location,
  }) {
    return BlueRicky(location ?? this.location);
  }
}
