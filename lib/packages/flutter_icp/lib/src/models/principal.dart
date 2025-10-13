/// ICP Principal model (simplified)
class ICPPrincipal {
  final String id;
  final List<int>? bytes;

  ICPPrincipal({
    required this.id,
    this.bytes,
  });

  factory ICPPrincipal.fromText(String text) {
    return ICPPrincipal(id: text);
  }

  factory ICPPrincipal.fromJson(Map<String, dynamic> json) {
    return ICPPrincipal(
      id: json['id'] ?? '',
      bytes: json['bytes'] != null ? List<int>.from(json['bytes']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bytes': bytes,
    };
  }

  @override
  String toString() => id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ICPPrincipal &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
