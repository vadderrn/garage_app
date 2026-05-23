// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import '../screens/screens.dart';

class NavigationNotifier extends ChangeNotifier {
  final List<Screen> _stack = [Screen.home];

  Screen get current => _stack.last;
  bool get canPop => _stack.length > 1;

  void push(Screen screen) {
    _stack.add(screen);
    notifyListeners();
  }

  void pop() {
    if (_stack.length > 1) {
      _stack.removeLast();
      notifyListeners();
    }
  }
}
