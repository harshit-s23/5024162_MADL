import 'package:flutter/material.dart';

class ScoreData {
  const ScoreData({
    required this.runs,
    required this.wickets,
    required this.log,
  });

  final int runs;
  final int wickets;
  final List<String> log;
}

class ScorecardScreen extends StatelessWidget {
  const ScorecardScreen({super.key, required this.data});

  final ScoreData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scorecard')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: ${data.runs} / ${data.wickets}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            const Text('Opened with Navigator.pushNamed()'),
            const Divider(height: 28),
            Expanded(
              child: data.log.isEmpty
                  ? const Center(child: Text('No balls played yet.'))
                  : ListView.builder(
                      itemCount: data.log.length,
                      itemBuilder: (context, index) => ListTile(
                        dense: true,
                        leading: Text('${data.log.length - index}'),
                        title: Text(data.log[index]),
                      ),
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: const Key('resetButton'),
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text('Reset match and go back'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                key: const Key('backButton'),
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Back without resetting'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
