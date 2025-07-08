// lib/viewmodels/age_calculator_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../models/age_result_model.dart';
import '../services/calculation_service.dart';

class AgeCalculatorViewModel extends ChangeNotifier {
  final CalculationService _calculationService = CalculationService();

  DateTime? _selectedDate;
  AgeResult? _ageResult;

  DateTime? get selectedDate => _selectedDate;
  AgeResult? get ageResult => _ageResult;

  void updateAndCalculateAge(DateTime newDate) {
    if (newDate == _selectedDate) {
      return;
    }

    _selectedDate = newDate;
    _ageResult = _calculationService.calculateAge(_selectedDate!);

    notifyListeners();
  }

  void clear() {
    _selectedDate = null;
    _ageResult = null;
    notifyListeners();
  }
}