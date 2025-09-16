class PushPayload {
  final String type;
  final String? value;
  final int? id;
  final int? badge;
  final Map<String, dynamic> raw;

  PushPayload({
    required this.type,
    required this.raw,
    this.value,
    this.id,
    this.badge,
  });

  factory PushPayload.fromMap(Map<dynamic, dynamic> m) {
    final map = m.map((k, v) => MapEntry(k.toString(), v));
    final type = (map['type']?.toString() ?? '').trim().toUpperCase();
    return PushPayload(
      type: type,
      value: map['value']?.toString(),
      id: int.tryParse(map['id']?.toString() ?? ''),
      badge: int.tryParse(map['badge']?.toString() ?? ''),
      raw: Map<String, dynamic>.from(map),
    );
  }
}
