import 'package:flutter/material.dart';

void main() {
  runApp(const MyHelloApp());
}

class MyHelloApp extends StatelessWidget {
  const MyHelloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World',
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Flutter Hello World')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.waving_hand, size: 60),
              const SizedBox(height: 20),
              const Text('Hello World', style: TextStyle(fontSize: 28)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Hello World button pressed');
                },
                child: const Text('Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
