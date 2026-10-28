import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Expense {
  const Expense({
    required this.title,
    required this.amount,
    required this.category,
  });

  final String title;
  final double amount;
  final String category;

  String toCsv() => '$title,$amount,$category';

  static Expense? fromCsv(String line) {
    final parts = line.split(',');
    if (parts.length != 3) return null;
    final amount = double.tryParse(parts[1]);
    if (amount == null) return null;
    return Expense(title: parts[0], amount: amount, category: parts[2]);
  }
}

class ExpenseFile {
  static const String fileName = 'harshit_expenses.csv';

  Future<File> get _file async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$fileName');
  }

  Future<String> get path async => (await _file).path;

  Future<void> add(Expense expense) async {
    try {
      final file = await _file;
      await file.writeAsString(
        '${expense.toCsv()}\n',
        mode: FileMode.append,
        flush: true,
      );
    } on FileSystemException catch (error) {
      throw Exception('Unable to save expense: ${error.message}');
    }
  }

  Future<List<Expense>> readAll() async {
    try {
      final file = await _file;
      if (!await file.exists()) {
        await file.writeAsString(
          'Lunch,120.0,Food\nBus pass,350.0,Travel\n',
          flush: true,
        );
      }
      final lines = await file.readAsLines();
      return lines.map(Expense.fromCsv).whereType<Expense>().toList();
    } on FileSystemException catch (error) {
      throw Exception('Unable to read expenses: ${error.message}');
    }
  }

  Future<void> removeAt(int index) async {
    try {
      final items = await readAll();
      if (index < 0 || index >= items.length) return;
      items.removeAt(index);
      final file = await _file;
      final text = items.map((e) => '${e.toCsv()}\n').join();
      await file.writeAsString(text, flush: true);
    } on FileSystemException catch (error) {
      throw Exception('Unable to update file: ${error.message}');
    }
  }
}
