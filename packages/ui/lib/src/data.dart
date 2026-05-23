// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'models.dart';

const Map<String, CategoryInfo> categories = {
  'maintenance': CategoryInfo(icon: '\u{1F527}', label: 'Maintenance', colorValue: 0xFF30d158),
  'repair': CategoryInfo(icon: '\u{1F528}', label: 'Repair', colorValue: 0xFFff9f0a),
  'replacement': CategoryInfo(icon: '\u{1F504}', label: 'Replacement', colorValue: 0xFFff6b6b),
  'diagnostic': CategoryInfo(icon: '\u{1F50D}', label: 'Diagnostic', colorValue: 0xFF5ac8fa),
  'tires': CategoryInfo(icon: '\u{1F6DE}', label: 'Tires & Wheels', colorValue: 0xFFaf52de),
  'fuel': CategoryInfo(icon: '\u{26FD}', label: 'Fuel', colorValue: 0xFFffd700),
  'insurance': CategoryInfo(icon: '\u{1F6E1}', label: 'Insurance', colorValue: 0xFF6495ed),
  'cleaning': CategoryInfo(icon: '\u{1F9F9}', label: 'Cleaning', colorValue: 0xFF00ced1),
  'tax': CategoryInfo(icon: '\u{1F4CB}', label: 'Tax & Fees', colorValue: 0xFF8b5a2b),
  'parking': CategoryInfo(icon: '\u{1F17F}', label: 'Parking', colorValue: 0xFF808080),
};

const List<PresetColor> presetColors = [
  PresetColor(name: 'Black', hex: '#1a1a1a'),
  PresetColor(name: 'White', hex: '#f5f5f5'),
  PresetColor(name: 'Gray', hex: '#808080'),
  PresetColor(name: 'Red', hex: '#cc0000'),
  PresetColor(name: 'Blue', hex: '#1e3a8a'),
  PresetColor(name: 'Green', hex: '#0d6b0d'),
  PresetColor(name: 'Yellow', hex: '#ffd700'),
  PresetColor(name: 'Orange', hex: '#e67e22'),
  PresetColor(name: 'Brown', hex: '#5c3a1e'),
  PresetColor(name: 'Purple', hex: '#7b2d8b'),
  PresetColor(name: 'Pink', hex: '#e91e63'),
];
