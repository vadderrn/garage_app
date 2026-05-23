// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';

extension TabletContextX on BuildContext {
  bool get isTablet => MediaQuery.of(this).size.width >= 600;
}
