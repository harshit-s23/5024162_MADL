import 'package:flutter/material.dart';

void main() {
  runApp(const DesignDemo());
}

class DesignDemo extends StatelessWidget {
  const DesignDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade100,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(),
        ),
      ),
      home: const DesignHome(),
    );
  }
}

class DesignHome extends StatefulWidget {
  const DesignHome({super.key});

  @override
  State<DesignHome> createState() => _DesignHomeState();
}

class _DesignHomeState extends State<DesignHome> {
  final TextEditingController cityController = TextEditingController();
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Common Widgets'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Column(
                children: [
                  Icon(Icons.dashboard, size: 55),
                  SizedBox(height: 10),
                  Text(
                    'My Flutter Dashboard',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.phone, size: 32),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.email, size: 32),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'Enter your city',
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                setState(() {
                  submitted = true;
                });
                debugPrint('City entered: ${cityController.text}');
              },
              child: const Text('Show Message'),
            ),
            const SizedBox(height: 20),
            if (submitted)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Welcome from ${cityController.text}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
