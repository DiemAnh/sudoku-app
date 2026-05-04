class Parser {
  static List<List<int>> fromString(String input) {
    List<String> lines = input.trim().split('\n');

    return lines.map((line) {
      return line.split('').map((e) => int.parse(e)).toList();
    }).toList();
  }
}