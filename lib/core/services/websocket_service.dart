// WebSocketService - Minimal wrapper for web updates in Admin Dashboard (mock implementation ready).
import 'dart:async';

class WebSocketService {
  Timer? _timer;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  void startMock() {
    stop();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _controller.add({
        'timestamp': DateTime.now().toIso8601String(),
        'metric': 'orders_per_minute',
        'value': (50 + (100 * (DateTime.now().millisecond % 10) / 10)).round(),
      });
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
