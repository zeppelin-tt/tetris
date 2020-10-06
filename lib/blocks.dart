class Block {
  List<int> location;

  Block(this.location);

  List<int> tryTwist() => location;

  void moveDown() => location = List.of(location.map((i) => i + 10));

  void moveRight(int pixels) => location = List.of(location.map((i) => i + pixels));

  void moveLeft(int pixels) => location = List.of(location.map((i) => i - pixels));

  List<int> tryMoveRight(int pixels) => List.of(location.map((i) => i + pixels));

  List<int> tryMoveLeft(int pixels) => List.of(location.map((i) => i - pixels));

  void changeLocation(List<int> newLocation) => location = List.of(newLocation);

  List<int> get rightSurface => location.where((e) => !location.contains(e + 1)).toList();

  List<int> get leftSurface => location.where((e) => !location.contains(e - 1)).toList();

  @override
  String toString() {
    return 'Block{location: $location}';
  }

}

class EmptyBlock extends Block {
  EmptyBlock() : super([]);
}

class HeroBlock extends Block {
  HeroBlock(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 1 == location[1]) {
      return [location[0] + 22, location[1] + 11, location[2], location[3] - 11];
    } else {
      return [location[3] - 22, location[2] - 11, location[1], location[0] + 11];
    }
  }
}

class Smashboy extends Block {
  Smashboy(List<int> locations) : super(locations);
}

class Teewee extends Block {
  Teewee(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 1 == location[1]) {
      return [location[0], location[1], location[2] - 11, location[3]];
    } else if (location.last - 10 == location[2]) {
      return [location[0], location[1], location[2], location[3] - 9];
    } else if (location.last - 1 == location[2]) {
      return [location[0], location[1] + 11, location[2], location[3]];
    } else {
      return [location[0] + 9, location[1], location[2], location[3]];
    }
  }
}

class RhodeIsland extends Block {
  RhodeIsland(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 1 == location[1]) {
      return [
        location[0],
        location[1],
        location[2] + 2,
        location[3] - 20,
      ];
    } else {
      return [location[0] + 20, location[1], location[2], location[3] - 2];
    }
  }
}

class Cleveland extends Block {
  Cleveland(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 1 == location[1]) {
      return [location[0], location[1], location[2] - 20, location[3] - 2];
    } else {
      return [location[0] + 20, location[1], location[2], location[3] + 2];
    }
  }
}

class OrangeRicky extends Block {
  OrangeRicky(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 8 == location[1]) {
      return [location[0] + 20, location[1] - 9, location[2], location[3] + 9];
    } else if (location[1] + 11 == location.last) {
      return [location[0] + 11, location[1], location[2] - 11, location[3] - 2];
    } else if (location[2] + 8 == location.last) {
      return [location[0] + 11, location[1], location[2] - 11, location[3] + 2];
    } else {
      return [location[0] + 2, location[1], location[2] + 11, location[3] - 11];
    }
  }
}

class BlueRicky extends Block {
  BlueRicky(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 11 == location[2]) {
      return [location[0] + 2, location[1] - 9, location[2], location[3] + 9];
    } else if (location[1] + 19 == location.last) {
      return [
        location[0] + 11,
        location[1] + 20,
        location[2],
        location[3] - 11,
      ];
    } else if (location[1] + 11 == location.last) {
      return [location[0] - 9, location[1], location[2] + 9, location[3] - 2];
    } else {
      return [location[0] + 11, location[1], location[2] - 20, location[3] - 11];
    }
  }
}
