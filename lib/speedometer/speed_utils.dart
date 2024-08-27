enum DistanceType {
  meter("m"),
  kilometer("km"),
  feet("ft"),
  mile("mi");

  final String name;
  const DistanceType(this.name);
}

DistanceType getDistanceType(bool isKMPH, double meters) {
  if (isKMPH) {
    if (meters < 1000) {
      return DistanceType.meter;
    } else {
      return DistanceType.kilometer;
    }
  } else {
    if (meters < 1609.34) {
      return DistanceType.feet;
    } else {
      return DistanceType.mile;
    }
  }
}

int convertSpeed(double speedInMetersPerSecond, bool isKMPH) {
  if (isKMPH) {
    return (speedInMetersPerSecond * 3.6)
        .round(); // Convert to kilometers per hour
  } else {
    return (speedInMetersPerSecond * 2.23694)
        .round(); // Convert to miles per hour
  }
}

String convertDistance(double meters, DistanceType type) {
  switch (type) {
    case DistanceType.meter:
      return meters.toStringAsFixed(0);
    case DistanceType.kilometer:
      return (meters / 1000).toStringAsFixed(3);
    case DistanceType.feet:
      return (meters * 3.28084).toStringAsFixed(0);
    case DistanceType.mile:
      return (meters * 0.000621371).toStringAsFixed(3);
  }
}
