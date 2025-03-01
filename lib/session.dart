class Session {
  final int duration; // Session length in seconds
  final int debrisCount;
  final String notes; // Optional session notes

  Session({
    required this.duration,
    required this.debrisCount,
    this.notes = "",
  });

  String getTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${hours}hr ${minutes}m ${remainingSeconds}s";
  }
}