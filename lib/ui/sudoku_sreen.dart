import 'package:flutter/material.dart';
import '../solver/sudoku_solver.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  final solver = SudokuSolver();

  List<List<int>> board = List.generate(9, (_) => List.filled(9, 0));
  List<List<int>> previousBoard = List.generate(9, (_) => List.filled(9, 0));

  List<List<List<int>>> solutions = [];
  int currentIndex = 0;

  List<List<bool>> isSolved = List.generate(
    9,
    (_) => List.generate(9, (_) => false),
  );

  int? selectedRow;
  int? selectedCol;

  List<List<int>> clone(List<List<int>> b) =>
      b.map((e) => List<int>.from(e)).toList();

  void solveOne() {
    previousBoard = clone(board);

    List<List<int>> before = clone(board);

    setState(() {
      board = solver.solveOneCopy(board);
      markSolved(before, board);
      solutions = [];
      currentIndex = 0;
    });
  }

  void solveAll() {
    previousBoard = clone(board);

    List<List<int>> before = clone(board);

    solutions = solver.solveAll(board, limit: 10);
    currentIndex = 0;

    if (solutions.isNotEmpty) {
      board = clone(solutions.first);
    }

    setState(() {
      markSolved(before, board);
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Solutions"),
        content: Text("Found: ${solutions.length} solutions"),
      ),
    );
  }

  void next() {
    if (solutions.isEmpty) return;

    setState(() {
      currentIndex = (currentIndex + 1) % solutions.length;
      board = clone(solutions[currentIndex]);
    });
  }

  void prev() {
    if (solutions.isEmpty) return;

    setState(() {
      currentIndex =
          (currentIndex - 1 + solutions.length) % solutions.length;
      board = clone(solutions[currentIndex]);
    });
  }

  void undo() {
    setState(() {
      board = clone(previousBoard);
      solutions = [];
      currentIndex = 0;
    });
  }

  void clear() {
    setState(() {
      board = List.generate(9, (_) => List.filled(9, 0));
      isSolved = List.generate(
        9,
        (_) => List.generate(9, (_) => false),
      );
      solutions = [];
      currentIndex = 0;
    });
  }

  void markSolved(List<List<int>> before, List<List<int>> after) {
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (before[i][j] == 0 && after[i][j] != 0) {
          isSolved[i][j] = true;
        }
      }
    }
  }

  void inputNumber(int val) {
    if (selectedRow == null || selectedCol == null) return;

    setState(() {
      board[selectedRow!][selectedCol!] = val;
      isSolved[selectedRow!][selectedCol!] = false;
    });
  }

  Widget cell(int r, int c) {
    bool selected = selectedRow == r && selectedCol == c;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRow = r;
          selectedCol = c;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(1),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.grey.shade300 : null,
          border: Border.all(color: Colors.black26),
        ),
        child: Text(
          board[r][c] == 0 ? '' : board[r][c].toString(),
          style: TextStyle(
            fontSize: 20,
            color: isSolved[r][c] ? Colors.blue : Colors.black,
            fontWeight:
                isSolved[r][c] ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget keypad() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(9, (i) {
        return Padding(
          padding: const EdgeInsets.all(4),
          child: ElevatedButton(
            onPressed: () => inputNumber(i + 1),
            child: Text("${i + 1}"),
          ),
        );
      }),
    );
  }

  Widget buttons() {
    return Column(
      children: [

        keypad(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: solveOne, child: const Text("Solve 1")),
            ElevatedButton(onPressed: solveAll, child: const Text("Solve All")),
            ElevatedButton(onPressed: undo, child: const Text("Back")),
            ElevatedButton(onPressed: clear, child: const Text("Clear")),
          ],
        ),
        const SizedBox(height: 10),
        if (solutions.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: prev, icon: const Icon(Icons.arrow_left)),
              Text("${currentIndex + 1}/${solutions.length}"),
              IconButton(onPressed: next, icon: const Icon(Icons.arrow_right)),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sudoku Solver")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  itemCount: 81,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 9,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (_, i) => cell(i ~/ 9, i % 9),
                ),
              ),
            ),
            buttons(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}