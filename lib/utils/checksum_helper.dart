mixin ChecksumHelper {
  int calculateChecksum(String input) {
    final weights = [7, 3, 1];
    int checksum = 0;

    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      int value;
      if (RegExp(r'[0-9]').hasMatch(char)) {
        value = int.parse(char); // Numeric value for digits
      } else if (RegExp(r'[A-Z]').hasMatch(char)) {
        value = char.codeUnitAt(0) - 'A'.codeUnitAt(0) + 10;
      } else if (char == '<') {
        value = 0;
      } else {
        throw Exception("Invalid character in MRZ: $char");
      }
      checksum += value * weights[i % weights.length];
    }
    return checksum % 10;
  }
}
