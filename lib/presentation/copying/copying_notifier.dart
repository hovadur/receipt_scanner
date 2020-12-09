import 'package:flutter/material.dart';

class CopyingNotifier extends ChangeNotifier {
  int selectedDate = 0;

  void setSelectedDate(int value) {
    selectedDate = value;
    notifyListeners();
  }
}
