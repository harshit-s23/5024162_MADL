import 'package:flutter/material.dart';

void main() {
  runApp(const FeedbackApp());
}

class FeedbackApp extends StatelessWidget {
  const FeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const FeedbackPage(),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final formKey = GlobalKey<FormState>();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  String selectedCategory = 'General';
  bool urgent = false;

  void sendFeedback() {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.feedback,
                    size: 45,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Send Feedback',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  hintText: 'Enter feedback subject',
                  prefixIcon: Icon(Icons.subject),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Subject is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'General',
                    child: Text('General'),
                  ),
                  DropdownMenuItem(
                    value: 'Suggestion',
                    child: Text('Suggestion'),
                  ),
                  DropdownMenuItem(
                    value: 'Complaint',
                    child: Text('Complaint'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value ?? 'General';
                  });
                },
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Your Message',
                  hintText: 'Write your feedback here',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 10) {
                    return 'Message must contain at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: const Text('Mark as urgent'),
                secondary: const Icon(Icons.priority_high),
                value: urgent,
                onChanged: (value) {
                  setState(() {
                    urgent = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: sendFeedback,
                  icon: const Icon(Icons.send),
                  label: const Text('Send Feedback'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
