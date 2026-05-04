import 'package:flutter/material.dart';
import 'package:sudoku_app/ui/sudoku_sreen.dart';
void main() {
  runApp(const SudokuApp());
}

class SudokuApp extends StatelessWidget {
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Solver',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SudokuScreen(),
    );
  }
}