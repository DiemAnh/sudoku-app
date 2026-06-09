import 'package:sudoku_app/linked_list.dart';

class Parser {
  static LinkedList<LinkedList<int>> fromString(String input) {
    LinkedList<String> lines = LinkedList.from(input.trim().split('\n'));

    return lines.mapped((line) {
      return LinkedList<int>.from(line.split('').map((e) => int.parse(e)));
    });
  }
}