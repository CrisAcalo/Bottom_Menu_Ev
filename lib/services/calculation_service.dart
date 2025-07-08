import '../models/age_result_model.dart';
import '../models/triangle_model.dart';

class CalculationService {
  // Constante para tolerancia de comparación con doubles
  static const double epsilon = 1e-10;

  AgeResult calculateAge(DateTime birthDate) {
    final DateTime now = DateTime.now();
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;

    if (days < 0) {
      months--;
      days += DateTime(now.year, now.month, 0).day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    return AgeResult(years: years, months: months, days: days);
  }

  TriangleType classifyTriangle(double a, double b, double c) {
    // Verifica si es un triángulo inválido (longitudes negativas o violación de desigualdad triangular)
    if (_isInvalidTriangle(a, b, c)) {
      return TriangleType.Invalido;
    }

    // Clasificación según los lados
    if (_areEqual(a, b) && _areEqual(b, c)) {
      return TriangleType.Equilatero;
    } else if (_areEqual(a, b) || _areEqual(b, c) || _areEqual(a, c)) {
      return TriangleType.Isosceles;
    } else {
      return TriangleType.Escaleno;
    }
  }

  // Función para comparar dos doubles con margen de error
  bool _areEqual(double x, double y) {
    return (x - y).abs() < epsilon;
  }

  // Verificación de triángulo inválido considerando errores de precisión
  bool _isInvalidTriangle(double a, double b, double c) {
    return a <= 0 || b <= 0 || c <= 0 ||
        (a + b <= c + epsilon) ||
        (a + c <= b + epsilon) ||
        (b + c <= a + epsilon);
  }
}
