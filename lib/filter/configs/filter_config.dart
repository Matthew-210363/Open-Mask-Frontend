
abstract class FilterConfig {
  /// Ein eindeutiger Schlüssel, z.B. für Serialisierung.
  final String id;

  FilterConfig({required this.id});

  /// Für JSON‑Serialisierung und Deserialisierung.
  Map<String, dynamic> toJSON();
}