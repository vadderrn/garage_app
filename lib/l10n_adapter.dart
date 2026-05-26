// Copyright (c) 2026 vadderrn
// SPDX-License-Identifier: MIT

import 'package:backend/backend.dart';
import 'l10n/app_localizations.g.dart';

class AppL10nAdapter implements L10n {
  final AppLocalizations _delegate;

  AppL10nAdapter(this._delegate);

  @override
  String get appTitle => _delegate.appTitle;

  @override
  String get garage => _delegate.garage;

  @override
  String get settings => _delegate.settings;

  @override
  String get addCar => _delegate.addCar;

  @override
  String get addWork => _delegate.addWork;

  @override
  String get editCar => _delegate.editCar;

  @override
  String get editWork => _delegate.editWork;

  @override
  String get deleteCar => _delegate.deleteCar;

  @override
  String get deleteWork => _delegate.deleteWork;

  @override
  String get cancel => _delegate.cancel;

  @override
  String get delete => _delegate.delete;

  @override
  String get close => _delegate.close;

  @override
  String get save => _delegate.save;

  @override
  String get donate => _delegate.donate;

  @override
  String get preferences => _delegate.preferences;

  @override
  String get language => _delegate.language;

  @override
  String get distanceUnit => _delegate.distanceUnit;

  @override
  String get theme => _delegate.theme;

  @override
  String get dark => _delegate.dark;

  @override
  String get light => _delegate.light;

  @override
  String get system => _delegate.system;

  @override
  String get totalSpent => _delegate.totalSpent;

  @override
  String get avgService => _delegate.avgService;

  @override
  String get lastService => _delegate.lastService;

  @override
  String get topCategory => _delegate.topCategory;

  @override
  String get serviceHistory => _delegate.serviceHistory;

  @override
  String get tapDetails => _delegate.tapDetails;

  @override
  String get tapMonthlyDetails => _delegate.tapMonthlyDetails;

  @override
  String get thisMonth => _delegate.thisMonth;

  @override
  String get vsPrevMonth => _delegate.vsPrevMonth;

  @override
  String get noChange => _delegate.noChange;

  @override
  String get more => _delegate.more;

  @override
  String get less => _delegate.less;

  @override
  String get monthlySpending => _delegate.monthlySpending;

  @override
  String get oilLife => _delegate.oilLife;

  @override
  String get sinceChange => _delegate.sinceChange;

  @override
  String get max => _delegate.max;

  @override
  String get good => _delegate.good;

  @override
  String get dueSoon => _delegate.dueSoon;

  @override
  String get overdue => _delegate.overdue;

  @override
  String get supportDev => _delegate.supportDev;

  @override
  String get helpKeepFree => _delegate.helpKeepFree;

  @override
  String get customAmount => _delegate.customAmount;

  @override
  String get year => _delegate.year;

  @override
  String get mileage => _delegate.mileage;

  @override
  String get totalSpentLabel => _delegate.totalSpentLabel;

  @override
  String get workRecords => _delegate.workRecords;

  @override
  String get record => _delegate.record;

  @override
  String get noOilRecords => _delegate.noOilRecords;

  @override
  String get description => _delegate.description;

  @override
  String get date => _delegate.date;

  @override
  String get cost => _delegate.cost;

  @override
  String get category => _delegate.category;

  @override
  String get thanks => _delegate.thanks;

  @override
  String get popular => _delegate.popular;

  @override
  String get english => _delegate.english;

  @override
  String get russian => _delegate.russian;

  @override
  String get km => _delegate.km;

  @override
  String get mi => _delegate.mi;

  @override
  String get now => _delegate.now;

  @override
  String get sinceChangeKm => _delegate.sinceChangeKm;

  @override
  String get maxKm => _delegate.maxKm;

  @override
  String get thisMonthSpent => _delegate.thisMonthSpent;

  @override
  String confirmDeleteCar(Object car) => _delegate.confirmDeleteCar(car);

  @override
  String get confirmDeleteWork => _delegate.confirmDeleteWork;

  @override
  String get noCars => _delegate.noCars;

  @override
  String get totalLabel => _delegate.totalLabel;

  @override
  String get topCategoryTap => _delegate.topCategoryTap;

  @override
  String get coffee => _delegate.coffee;

  @override
  String get pizza => _delegate.pizza;

  @override
  String get beer => _delegate.beer;

  @override
  String get make => _delegate.make;

  @override
  String get model => _delegate.model;

  @override
  String get plate => _delegate.plate;

  @override
  String get price => _delegate.price;

  @override
  String get mileageForm => _delegate.mileageForm;

  @override
  String get color => _delegate.color;

  @override
  String get eg => _delegate.eg;

  @override
  String get spendingByCategory => _delegate.spendingByCategory;

  @override
  String get oilChangeHistory => _delegate.oilChangeHistory;

  @override
  String get workHint => _delegate.workHint;

  @override
  String get currency => _delegate.currency;

  @override
  String get usd => _delegate.usd;

  @override
  String get rub => _delegate.rub;

  @override
  String get eur => _delegate.eur;

  @override
  String get catMaintenance => _delegate.catMaintenance;

  @override
  String get catRepair => _delegate.catRepair;

  @override
  String get catReplacement => _delegate.catReplacement;

  @override
  String get catDiagnostic => _delegate.catDiagnostic;

  @override
  String get catTires => _delegate.catTires;

  @override
  String get catFuel => _delegate.catFuel;

  @override
  String get catInsurance => _delegate.catInsurance;

  @override
  String get catCleaning => _delegate.catCleaning;

  @override
  String get catTax => _delegate.catTax;

  @override
  String get catParking => _delegate.catParking;

  @override
  String get catOther => _delegate.catOther;

  @override
  String get month0 => _delegate.month0;

  @override
  String get month1 => _delegate.month1;

  @override
  String get month2 => _delegate.month2;

  @override
  String get month3 => _delegate.month3;

  @override
  String get month4 => _delegate.month4;

  @override
  String get month5 => _delegate.month5;

  @override
  String get month6 => _delegate.month6;

  @override
  String get month7 => _delegate.month7;

  @override
  String get month8 => _delegate.month8;

  @override
  String get month9 => _delegate.month9;

  @override
  String get month10 => _delegate.month10;

  @override
  String get month11 => _delegate.month11;

  @override
  String get makeRequired => _delegate.makeRequired;

  @override
  String get modelRequired => _delegate.modelRequired;

  @override
  String get yearInvalid => _delegate.yearInvalid;

  @override
  String get priceInvalid => _delegate.priceInvalid;

  @override
  String get mileageInvalid => _delegate.mileageInvalid;

  @override
  String get descRequired => _delegate.descRequired;

  @override
  String get dateRequired => _delegate.dateRequired;

  @override
  String get costInvalid => _delegate.costInvalid;
  @override
  String get data => _delegate.data;
  @override
  String get exportCsv => _delegate.exportCsv;
  @override
  String get importCsv => _delegate.importCsv;
  @override
  String get importConfirm => _delegate.importConfirm;
  @override
  String get importSuccess => _delegate.importSuccess;
  @override
  String get importError => _delegate.importError;
}
