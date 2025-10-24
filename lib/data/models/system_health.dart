/// System health status model
/// Monitors backend health, memory usage, and error rates
class SystemHealth {
  final String status; // 'OK', 'Warning', 'Error'
  final int errorsLastHour;
  final double memoryUsage; // Percentage (0-100)
  final double cpuUsage; // Percentage (0-100)
  final int activeConnections;
  final DateTime timestamp;

  SystemHealth({
    required this.status,
    required this.errorsLastHour,
    required this.memoryUsage,
    this.cpuUsage = 0,
    this.activeConnections = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory SystemHealth.fromJson(Map<String, dynamic> json) {
    return SystemHealth(
      status: json['status'] ?? 'Unknown',
      errorsLastHour: json['errorsLastHour'] ?? 0,
      memoryUsage: (json['memoryUsage'] ?? 0).toDouble(),
      cpuUsage: (json['cpuUsage'] ?? 0).toDouble(),
      activeConnections: json['activeConnections'] ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'errorsLastHour': errorsLastHour,
      'memoryUsage': memoryUsage,
      'cpuUsage': cpuUsage,
      'activeConnections': activeConnections,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SystemHealth.empty() => SystemHealth(
        status: 'Unknown',
        errorsLastHour: 0,
        memoryUsage: 0,
        timestamp: DateTime.now(),
      );

  bool get isHealthy => status == 'OK';
  bool get hasWarning => status == 'Warning';
  bool get hasError => status == 'Error';

  SystemHealth copyWith({
    String? status,
    int? errorsLastHour,
    double? memoryUsage,
    double? cpuUsage,
    int? activeConnections,
    DateTime? timestamp,
  }) {
    return SystemHealth(
      status: status ?? this.status,
      errorsLastHour: errorsLastHour ?? this.errorsLastHour,
      memoryUsage: memoryUsage ?? this.memoryUsage,
      cpuUsage: cpuUsage ?? this.cpuUsage,
      activeConnections: activeConnections ?? this.activeConnections,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
