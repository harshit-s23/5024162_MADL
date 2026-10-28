import 'package:flutter/material.dart';
import 'rules_screen.dart';
import 'scorecard_screen.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  int _runs = 0;
  int _wickets = 0;
  final List<String> _log = [];
  Color _cardColor = const Color(0xFFE8F5E9);

  void _record(
    String event,
    Color color, {
    int runs = 0,
    int wickets = 0,
  }) {
    setState(() {
      _runs += runs;
      _wickets += wickets;
      _cardColor = color;
      _log.insert(0, event);
    });
  }

  void _onTap() {
    _record('Single tap: +1 run', const Color(0xFFC8E6C9), runs: 1);
  }

  void _onDoubleTap() {
    _record('Double tap: boundary +4', const Color(0xFFBBDEFB), runs: 4);
  }

  void _onLongPress() {
    if (_wickets >= 10) {
      _message('All out - reset the match to continue.');
      return;
    }
    _record('Long press: wicket', const Color(0xFFFFCDD2), wickets: 1);
    _message('Wicket! Total wickets: $_wickets');
  }

  void _message(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _openScorecard() async {
    final shouldReset = await Navigator.pushNamed<bool>(
      context,
      '/scorecard',
      arguments: ScoreData(
        runs: _runs,
        wickets: _wickets,
        log: List<String>.of(_log),
      ),
    );
    if (shouldReset == true && mounted) {
      setState(() {
        _runs = 0;
        _wickets = 0;
        _log.clear();
        _cardColor = const Color(0xFFE8F5E9);
      });
      _message('Match reset from scorecard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiment 7'),
        centerTitle: true,
        actions: [
          GestureDetector(
            key: const Key('scoreboardIcon'),
            onTap: _openScorecard,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.scoreboard_rounded),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Score Keeper',
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tap = 1 run, double tap = 4 runs, long press = wicket.',
              ),
              const SizedBox(height: 20),
              GestureDetector(
                key: const Key('scoreCard'),
                onTap: _onTap,
                onDoubleTap: _onDoubleTap,
                onLongPress: _onLongPress,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF2E7D32)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$_runs / $_wickets',
                        style: textTheme.displayMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _log.isEmpty ? 'Waiting for first ball' : _log.first,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  key: const Key('rulesButton'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RulesScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.rule_rounded),
                  label: const Text('Match rules (Navigator.push)'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
