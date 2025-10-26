import 'package:flutter/material.dart';

// A minimal test app wrapper for integration tests.
class TestApp extends StatelessWidget {
  final Widget child;
  const TestApp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: child,
    );
  }
}
