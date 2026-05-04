/// Base interface for all OBS WebSocket event models.
///
/// All event classes implement this interface to provide consistent
/// JSON serialization and string representation.
abstract class BaseEvent {
  /// Converts the event to a JSON map.
  Map<String, dynamic> toJson();

  /// Returns a string representation of the event.
  @override
  String toString();
}
