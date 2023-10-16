import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';

class PrayerSettings with ChangeNotifier {
  CalculationMethod _calculationMethod = CalculationMethod.egyptian;

  CalculationMethod get calculationMethod => _calculationMethod;

  void setCalculationMethod(CalculationMethod method) {
    _calculationMethod = method;
    notifyListeners();
  }
}