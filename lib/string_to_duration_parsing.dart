extension DurationParsing on Duration {
  Duration fromString(String duration) {
    final units = duration.split(':');
    return Duration(
        hours: int.parse(units[0]),
        minutes: int.parse(units[1]),
        seconds: int.parse(units[2].split('.')[0]),
        milliseconds: int.parse(units[2].split('.')[1]));
  }
}
