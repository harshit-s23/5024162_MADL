import 'package:flutter/material.dart';
import 'score_screen.dart';
import 'scorecard_screen.dart';

void main() {
  runApp(const ScoreKeeperApp());
}

class ScoreKeeperApp extends StatelessWidget {
  const ScoreKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Score Keeper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ScoreScreen(),
        '/scorecard': (context) {
          final data =
              ModalRoute.of(context)!.settings.arguments as ScoreData;
          return ScorecardScreen(data: data);
        },
      },
    );
  }
}
