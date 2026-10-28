import 'package:flutter/material.dart';
import 'expense_file.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  static const List<String> _categories = ['Food', 'Travel', 'Study', 'Other'];

  final ExpenseFile _file = ExpenseFile();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  String _category = _categories.first;
  late Future<List<Expense>> _expenses;
  late Future<String> _path;

  @override
  void initState() {
    super.initState();
    _path = _file.path;
    _reload();
  }

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() => _expenses = _file.readAll());
  }

  void _show(String text, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: error ? Colors.red.shade800 : null,
        ),
      );
  }

  Future<void> _addExpense() async {
    final title = _title.text.trim().replaceAll(',', ' ');
    final amount = double.tryParse(_amount.text.trim());
    if (title.isEmpty || amount == null || amount <= 0) {
      _show('Enter a title and a valid amount.', error: true);
      return;
    }
    try {
      await _file.add(
        Expense(title: title, amount: amount, category: _category),
      );
      if (!mounted) return;
      _title.clear();
      _amount.clear();
      _reload();
      _show('Expense written to CSV file.');
    } catch (error) {
      if (!mounted) return;
      _show(error.toString(), error: true);
    }
  }

  Future<void> _delete(int index) async {
    try {
      await _file.removeAt(index);
      if (!mounted) return;
      _reload();
    } catch (error) {
      if (!mounted) return;
      _show(error.toString(), error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experiment 8'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expense Log',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      key: const Key('titleInput'),
                      controller: _title,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      key: const Key('amountInput'),
                      controller: _amount,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  DropdownButton<String>(
                    value: _category,
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => _category = value);
                    },
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    key: const Key('addButton'),
                    onPressed: _addExpense,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Save to CSV'),
                  ),
                ],
              ),
              const Divider(height: 24),
              Expanded(
                child: FutureBuilder<List<Expense>>(
                  future: _expenses,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text(
                        'File error: ${snapshot.error}',
                        key: const Key('errorText'),
                      );
                    }
                    final items = snapshot.data ?? <Expense>[];
                    final total =
                        items.fold<double>(0, (sum, e) => sum + e.amount);
                    return Column(
                      children: [
                        Card(
                          color:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: ListTile(
                            title: const Text('Total spent'),
                            trailing: Text(
                              'Rs. ${total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final e = items[index];
                              return ListTile(
                                dense: true,
                                title: Text(e.title),
                                subtitle: Text(e.category),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Rs. ${e.amount.toStringAsFixed(2)}'),
                                    IconButton(
                                      icon: const Icon(Icons.close_rounded),
                                      onPressed: () => _delete(index),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              FutureBuilder<String>(
                future: _path,
                builder: (context, snapshot) => Text(
                  snapshot.hasData
                      ? 'File path: ${snapshot.data}'
                      : 'Locating documents directory...',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
