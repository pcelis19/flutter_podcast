String durationConverter(Duration duration) {
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  if (duration.inHours < 1) {
    return "${twoDigitMinutes}m ${twoDigitSeconds}s";
  } else {
    return "${twoDigits(duration.inHours)}h ${twoDigitMinutes}m ${twoDigitSeconds}s";
  }
}

String twoDigits(int n) => n.toString().padLeft(2, "0");
