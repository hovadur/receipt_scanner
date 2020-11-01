extension IsValidINN on String {
  bool isValidINN() {
    final inn = trim();
    if (!_innPattern.hasMatch(inn)) {
      return false;
    }
    final length = inn.length;
    if (length == 12) {
      return _innStep(inn, 2, 1) && _innStep(inn, 1, 0);
    } else {
      return _innStep(inn, 1, 2);
    }
  }

  static final _innPattern = RegExp(r'\d{10}|\d{12}');
  static final _checkArr = [3, 7, 2, 4, 10, 3, 5, 9, 4, 6, 8];

  bool _innStep(String inn, int offset, int arrOffset) {
    var sum = 0;
    final length = inn.length;
    for (var i = 0; i < length - offset; i++) {
      sum += (inn.codeUnitAt(i) - '0'.codeUnitAt(0)) * _checkArr[i + arrOffset];
    }
    return (sum % 11) % 10 ==
        inn.codeUnitAt(length - offset) - '0'.codeUnitAt(0);
  }
}
