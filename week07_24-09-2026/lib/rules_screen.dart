import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const rules = <String>[
      'Single tap on the score card adds 1 run.',
      'Double tap adds 4 runs (boundary).',
      'Long press records a wicket.',
      'After 10 wickets the innings is over.',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Match Rules')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final rule in rules)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.sports_cricket_rounded, size: 20),
                    const SizedBox(width: 10),
                    Expanded(child: Text(rule)),
                  ],
                ),
              ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                key: const Key('rulesBackButton'),
                onPressed: () => Navigator.pop(context),
                child: const Text('Back (Navigator.pop)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
