import 'package:sudoku_app/linked_list.dart';

class Board {
  LinkedList<LinkedList<int>> grid;

  Board(this.grid);

  factory Board.empty() {
    return Board(LinkedList.generate(9, (_) => LinkedList.filled(9, 0)));
  }

  Board clone() {
    return Board(grid.mapped((row) => LinkedList<int>.from(row)));
  }
}