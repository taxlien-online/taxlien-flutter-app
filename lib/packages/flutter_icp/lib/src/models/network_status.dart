/// ICP Network Status model
class ICPNetworkStatus {
  final String version;
  final String replicaId;
  final DateTime timestamp;
  final Map<String, dynamic> metrics;
  final int? blockHeight;
  final String? status;

  ICPNetworkStatus({
    required this.version,
    required this.replicaId,
    required this.timestamp,
    required this.metrics,
    this.blockHeight,
    this.status,
  });

  factory ICPNetworkStatus.fromJson(Map<String, dynamic> json) {
    return ICPNetworkStatus(
      version: json['version'] ?? '',
      replicaId: json['replica_id'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      metrics: json['metrics'] ?? {},
      blockHeight: json['block_height'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'replica_id': replicaId,
      'timestamp': timestamp.toIso8601String(),
      'metrics': metrics,
      'block_height': blockHeight,
      'status': status,
    };
  }

  bool get isHealthy => status == 'healthy';
}
