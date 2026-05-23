// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:backend/backend.dart';

extension L10nX on BuildContext {
  L10n get l10n => read<L10n>();
}
