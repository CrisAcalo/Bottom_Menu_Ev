// lib/viewmodels/bottom_nav_viewmodel.dart

import 'package:flutter/foundation.dart';

class BottomNavViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onPageChanged(int index) {
    if (_currentIndex == index) return;

    _currentIndex = index;

    notifyListeners();
  }
}