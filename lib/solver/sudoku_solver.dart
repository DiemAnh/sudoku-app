class SudokuSolver {
  bool isValid(List<List<int>> board, int row, int col, int num) {
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

  bool solveOne(List<List<int>> board) {
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

  List<List<List<int>>> solveAll(List<List<int>> board, {int limit = 100}) {
    List<List<List<int>>> solutions = [];

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

      solutions.add(
        board.map((row) => List<int>.from(row)).toList(),
      );
    }

    backtrack();
    return solutions;
  }

List<List<int>> solveOneCopy(List<List<int>> input) {
  List<List<int>> board =
      input.map((e) => List<int>.from(e)).toList();

  _solve(board);
  return board;
}

bool _solve(List<List<int>> board) {
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