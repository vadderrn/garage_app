// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:ui/ui.dart';
import '../providers/providers.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onAddCar;
  final void Function(int carId) onTapCar;

  const HomeScreen({super.key, required this.onAddCar, required this.onTapCar});

  @override
  Widget build(BuildContext context) {
    final cars = context.watch<CarListNotifier>().cars;
    final s = context.watch<SettingsNotifier>();
    final currency = s.currency;
    final distanceUnit = s.distanceUnit;
    final isTablet = context.isTablet;

    final tabletBranch = LayoutBuilder(
      builder: (context, constraints) {
        final pad = isTablet ? 24.0 : 16.0;
        final cardWidth = (constraints.maxWidth - pad * 2 - 10) / 2;
        final cards = cars
            .map(
              (car) => CarCard(
                car: car,
                width: cardWidth,
                currency: currency,
                distanceUnit: distanceUnit,
                onTap: () => onTapCar(car.id),
              ),
            )
            .toList();
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(pad, 0, pad, 0),
          child: Wrap(spacing: 10, runSpacing: 10, children: cards),
        );
      },
    );

    final phoneBranch = ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      itemCount: cars.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CarCard(
          car: cars[index],
          currency: currency,
          distanceUnit: distanceUnit,
          onTap: () => onTapCar(cars[index].id),
        ),
      ),
    );

    final carList = isTablet ? tabletBranch : phoneBranch;

    return Column(
      children: [
        Expanded(child: carList),
        Padding(
          padding: EdgeInsets.fromLTRB(isTablet ? 24 : 16, 12, isTablet ? 24 : 16, 20),
          child: AddButton(label: context.l10n.addCar, onTap: onAddCar),
        ),
      ],
    );
  }
}
