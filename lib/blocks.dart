class Block {
  List<int> location;

  Block(this.location);

  List<int> tryTwist() => location;

  List<int> tryMoveRight(int pixels) => List.of(location.map((i) => i + pixels));

  List<int> tryMoveDown() => List.of(location.map((i) => i + 12));

  List<int> tryMoveLeft(int pixels) => List.of(location.map((i) => i - pixels));

  void changeLocation(List<int> newLocation) => location = List.of(newLocation);

  List<int> get rightSurface => location.where((e) => !location.contains(e + 1)).toList();

  List<int> get leftSurface => location.where((e) => !location.contains(e - 1)).toList();

  Block copyWith({
    List<int> location,
  }) => Block(location ?? this.location);

  @override
  String toString() {
    return 'Block{location: $location}';
  }
}

class EmptyBlock extends Block {
  EmptyBlock() : super([]);

  @override
  EmptyBlock copyWith({
    List<int> location,
  }) => EmptyBlock();
}

class HeroBlock extends Block {
  HeroBlock(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 1 == location[1]) {
      return [location[0] + 26, location[1] + 13, location[2], location[3] - 13];
    } else {
      return [location[3] - 26, location[2] - 13, location[1], location[0] + 13];
    }
  }

  @override
  HeroBlock copyWith({
    List<int> location,
  }) => HeroBlock(location ?? this.location);
}

class Smashboy extends Block {
  Smashboy(List<int> locations) : super(locations);

  @override
  Smashboy copyWith({
    List<int> location,
  }) => Smashboy(location ?? this.location);
}

class Teewee extends Block {
  Teewee(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 1 == location[1]) {
      return [location[0], location[1], location[2] - 13, location[3]];
    } else if (location.last - 12 == location[2]) {
      return [location[0], location[1], location[2], location[3] - 11];
    } else if (location.last - 1 == location[2]) {
      return [location[0], location[1] + 13, location[2], location[3]];
    } else {
      return [location[0] + 11, location[1], location[2], location[3]];
    }
  }

  @override
  Teewee copyWith({
    List<int> location,
  }) => Teewee(location ?? this.location);
}

class RhodeIsland extends Block {
  RhodeIsland(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 1 == location[1]) {
      return [location[0], location[1], location[2] + 2, location[3] - 24];
    } else {
      return [location[0] + 24, location[1], location[2], location[3] - 2];
    }
  }

  @override
  RhodeIsland copyWith({
    List<int> location,
  }) => RhodeIsland(location ?? this.location);
}

class Cleveland extends Block {
  Cleveland(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 1 == location[1]) {
      return [location[0], location[1], location[2] - 24, location[3] - 2];
    } else {
      return [location[0] + 24, location[1], location[2], location[3] + 2];
    }
  }

  @override
  Cleveland copyWith({
    List<int> location,
  }) => Cleveland(location ?? this.location);
}

class OrangeRicky extends Block {
  OrangeRicky(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 10 == location[1]) {
      return [location[0] + 24, location[1] - 9, location[2], location[3] + 9];
    } else if (location[1] + 13 == location.last) {
      return [location[0] + 13, location[1], location[2] - 13, location[3] - 2];
    } else if (location[2] + 10 == location.last) {
      return [location[0] + 13, location[1], location[2] - 13, location[3] + 2];
    } else {
      return [location[0] + 2, location[1], location[2] + 13, location[3] - 13];
    }
  }

  @override
  OrangeRicky copyWith({
    List<int> location,
  }) => OrangeRicky(location ?? this.location);
}

class BlueRicky extends Block {
  BlueRicky(List<int> locations) : super(locations);

  @override
  List<int> tryTwist() {
    location.sort();
    if (location.first + 13 == location[2]) {
      return [location[0] + 2, location[1] - 11, location[2], location[3] + 11];
    } else if (location[1] + 19 == location.last) {
      return [location[0] + 13, location[1] + 24, location[2], location[3] - 13];
    } else if (location[1] + 13 == location.last) {
      return [location[0] - 11, location[1], location[2] + 11, location[3] - 2];
    } else {
      return [location[0] + 13, location[1], location[2] - 24, location[3] - 13];
    }
  }

  @override
  BlueRicky copyWith({
    List<int> location,
  }) => BlueRicky(location ?? this.location);
}
