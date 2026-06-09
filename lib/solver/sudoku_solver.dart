import 'package:sudoku_app/linked_list.dart';

class SudokuSolver {
  bool isValid(LinkedList<LinkedList<int>> board, int row, int col, int num) {
    for (int i = 0; i < 9; i++) {
      if (board[row][i] == num) return false;
      if (board[i][col] == num) return false;
    }

    int startRow = row - row % 3;
    int startCol = col - col % 3;

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[startRow + i][startCol + j] == num) {
          return false;
        }
      }
    }

    return true;
  }

  bool solveOne(LinkedList<LinkedList<int>> board) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (board[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (isValid(board, row, col, num)) {
              board[row][col] = num;

              if (solveOne(board)) return true;

              board[row][col] = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }
  LinkedList<LinkedList<LinkedList<int>>> solveAll(LinkedList<LinkedList<int>> board, {int limit = 100}) {
    LinkedList<LinkedList<LinkedList<int>>> solutions = LinkedList<LinkedList<LinkedList<int>>>();

    void backtrack() {
      if (solutions.length >= limit) return;

      for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
          if (board[row][col] == 0) {
            for (int num = 1; num <= 9; num++) {
              if (isValid(board, row, col, num)) {
                board[row][col] = num;
                backtrack();
                board[row][col] = 0;
              }
            }
            return;
          }
        }
      }

      solutions.add(board.mapped((row) => LinkedList<int>.from(row)));
    }

    backtrack();
    return solutions;
  }

LinkedList<LinkedList<int>> solveOneCopy(LinkedList<LinkedList<int>> input) {
  LinkedList<LinkedList<int>> board = input.mapped((e) => LinkedList<int>.from(e));

  _solve(board);
  return board;
}

bool _solve(LinkedList<LinkedList<int>> board) {
  for (int r = 0; r < 9; r++) {
    for (int c = 0; c < 9; c++) {
      if (board[r][c] == 0) {
        for (int n = 1; n <= 9; n++) {
          if (isValid(board, r, c, n)) {
            board[r][c] = n;

            if (_solve(board)) return true;

            board[r][c] = 0;
          }
        }
        return false;
      }
    }
  }
  return true;
}
}