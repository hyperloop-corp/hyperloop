class Utils {
  static String get newTimestamp =>
      (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString();
}
