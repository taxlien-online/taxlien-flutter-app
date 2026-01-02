/// Alert criteria model
///
/// Represents a single matching condition for an alert
class AlertCriteria {
  final String id;
  final String type; // location, roi, price, property_type, interest_rate
  final String operator; // equals, greater_than, less_than, between, contains
  final dynamic value; // Can be String, double, List, etc.
  final dynamic secondaryValue; // For 'between' operator

  const AlertCriteria({
    required this.id,
    required this.type,
    required this.operator,
    required this.value,
    this.secondaryValue,
  });

  /// Create from JSON
  factory AlertCriteria.fromJson(Map<String, dynamic> json) {
    return AlertCriteria(
      id: json['id'] as String,
      type: json['type'] as String,
      operator: json['operator'] as String,
      value: json['value'],
      secondaryValue: json['secondaryValue'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'operator': operator,
      'value': value,
      'secondaryValue': secondaryValue,
    };
  }

  /// Get human-readable description
  String get description {
    switch (type) {
      case 'location':
        if (operator == 'equals') {
          return 'Location is $value';
        } else if (operator == 'contains') {
          return 'Location contains $value';
        }
        return 'Location $operator $value';

      case 'roi':
        if (operator == 'greater_than') {
          return 'ROI > ${value}%';
        } else if (operator == 'less_than') {
          return 'ROI < ${value}%';
        } else if (operator == 'between') {
          return 'ROI between ${value}% - ${secondaryValue}%';
        }
        return 'ROI $operator ${value}%';

      case 'price':
        if (operator == 'greater_than') {
          return 'Price > \$${_formatNumber(value)}';
        } else if (operator == 'less_than') {
          return 'Price < \$${_formatNumber(value)}';
        } else if (operator == 'between') {
          return 'Price \$${_formatNumber(value)} - \$${_formatNumber(secondaryValue)}';
        }
        return 'Price $operator \$${_formatNumber(value)}';

      case 'property_type':
        return 'Type is $value';

      case 'interest_rate':
        if (operator == 'greater_than') {
          return 'Interest > ${value}%';
        } else if (operator == 'less_than') {
          return 'Interest < ${value}%';
        } else if (operator == 'between') {
          return 'Interest ${value}% - ${secondaryValue}%';
        }
        return 'Interest $operator ${value}%';

      default:
        return '$type $operator $value';
    }
  }

  /// Format large numbers with commas
  String _formatNumber(dynamic num) {
    if (num == null) return '0';
    final value = num is String ? double.parse(num) : num;
    return value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// Copy with modifications
  AlertCriteria copyWith({
    String? id,
    String? type,
    String? operator,
    dynamic value,
    dynamic secondaryValue,
  }) {
    return AlertCriteria(
      id: id ?? this.id,
      type: type ?? this.type,
      operator: operator ?? this.operator,
      value: value ?? this.value,
      secondaryValue: secondaryValue ?? this.secondaryValue,
    );
  }
}
