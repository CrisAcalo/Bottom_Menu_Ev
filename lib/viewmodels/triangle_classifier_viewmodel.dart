import 'package:flutter/foundation.dart';
import '../models/triangle_model.dart';
import '../services/calculation_service.dart';

class TriangleClassifierViewModel extends ChangeNotifier {
  final CalculationService _calculationService = CalculationService();

  TriangleType _triangleType = TriangleType.Inicial;

  TriangleType get triangleType => _triangleType;

  void classifyTriangle(String sideA, String sideB, String sideC) {

    final double a = double.tryParse(sideA) ?? 0.0;
    final double b = double.tryParse(sideB) ?? 0.0;
    final double c = double.tryParse(sideC) ?? 0.0;

    _triangleType = _calculationService.classifyTriangle(a, b, c);

    notifyListeners();
  }

  void clear() {
    _triangleType = TriangleType.Inicial;
    notifyListeners();
  }
}