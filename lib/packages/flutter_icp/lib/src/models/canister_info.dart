/// ICP Canister Information model
class ICPCanisterInfo {
  final String id;
  final String status;
  final String? controller;
  final Map<String, dynamic>? moduleHash;
  final DateTime? createdAt;
  final int? memorySize;
  final double? cycles;
  final Map<String, dynamic>? settings;

  ICPCanisterInfo({
    required this.id,
    required this.status,
    this.controller,
    this.moduleHash,
    this.createdAt,
    this.memorySize,
    this.cycles,
    this.settings,
  });

  factory ICPCanisterInfo.fromJson(Map<String, dynamic> json) {
    return ICPCanisterInfo(
      id: json['id'] ?? '',
      status: json['status'] ?? 'unknown',
      controller: json['controller'],
      moduleHash: json['module_hash'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      memorySize: json['memory_size'],
      cycles:
          json['cycles'] != null ? (json['cycles'] as num).toDouble() : null,
      settings: json['settings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'controller': controller,
      'module_hash': moduleHash,
      'created_at': createdAt?.toIso8601String(),
      'memory_size': memorySize,
      'cycles': cycles,
      'settings': settings,
    };
  }

  bool get isRunning => status == 'running';
  bool get isStopped => status == 'stopped';
}
