class Board {
  List<List<int>> grid;

  Board(this.grid);

  factory Board.empty() {
    return Board(List.generate(9, (_) => List.filled(9, 0)));
  }

  Board clone() {
    return Board(grid.map((row) => List<int>.from(row)).toList());
  }
}