/// An enumeration representing the status of the device screen.
enum ScreenStatus {
  /// The screen is locked.
  locked("LOCKED"),

  /// The screen is unlocked.
  unlocked("UNLOCKED"),

  /// The screen status is unknown.
  unknown("UNKNOWN");

  /// The raw string value exchanged with the native platform.
  final String value;
  const ScreenStatus(this.value);

  /// Returns the [ScreenStatus] matching the raw platform [value], or [unknown].
  static ScreenStatus fromValue(String? value) => switch (value) {
    "LOCKED" => ScreenStatus.locked,
    "UNLOCKED" => ScreenStatus.unlocked,
    _ => ScreenStatus.unknown,
  };
}
