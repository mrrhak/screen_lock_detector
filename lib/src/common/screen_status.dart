enum ScreenStatus {
  locked("LOCKED"),
  unlocked("UNLOCKED"),
  unknown("UNKNOWN");

  final String name;
  const ScreenStatus(this.name);

  bool get isLocked => index == locked.index;
  bool get isUnlocked => index == unlocked.index;
}
