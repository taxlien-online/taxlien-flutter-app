/// ICP Transaction model
class ICPTransaction {
  final String id;
  final String from;
  final String to;
  final double amount;
  final double fee;
  final DateTime timestamp;
  final String status;
  final String? memo;
  final int? blockHeight;

  ICPTransaction({
    required this.id,
    required this.from,
    required this.to,
    required this.amount,
    required this.fee,
    required this.timestamp,
    required this.status,
    this.memo,
    this.blockHeight,
  });

  factory ICPTransaction.fromJson(Map<String, dynamic> json) {
    return ICPTransaction(
      id: json['id'] ?? '',
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      fee: (json['fee'] ?? 0).toDouble(),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      status: json['status'] ?? 'pending',
      memo: json['memo'],
      blockHeight: json['block_height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'amount': amount,
      'fee': fee,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'memo': memo,
      'block_height': blockHeight,
    };
  }

  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';
  bool get isFailed => status == 'failed';
}
