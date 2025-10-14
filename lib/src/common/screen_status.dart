/// An enumeration representing the status of the device screen.
enum ScreenStatus {
  /// The screen is locked.
  locked("LOCKED"),

  /// The screen is unlocked.
  unlocked("UNLOCKED"),

  /// The screen status is unknown.
  unknown("UNKNOWN");

  /// The string representation of the screen status.
  final String name;
  const ScreenStatus(this.name);
}
