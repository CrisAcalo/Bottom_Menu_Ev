// lib/viewmodels/weather_viewmodel.dart

import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import '../repositories/weather_repository.dart';

// Enum para gestionar los estados de la vista de forma clara.
enum ViewState { Idle, Loading, Success, Error }

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _weatherRepository = WeatherRepository();

  // --- ESTADO ---
  ViewState _state = ViewState.Idle;
  Weather? _weather;
  String _errorMessage = '';

  // --- GETTERS PÚBLICOS ---
  ViewState get state => _state;
  Weather? get weather => _weather;
  String get errorMessage => _errorMessage;

  // --- LÓGICA ---
  Future<void> fetchWeather(String city) async {
    // 1. Validar entrada. Si la ciudad está vacía, no hacer nada.
    if (city.isEmpty) {
      _state = ViewState.Idle;
      _weather = null;
      notifyListeners();
      return;
    }

    // 2. Iniciar carga
    _state = ViewState.Loading;
    notifyListeners();

    try {
      // 3. Llamar al repositorio para obtener los datos
      final fetchedWeather = await _weatherRepository.fetchWeather(city);
      _weather = fetchedWeather;
      _state = ViewState.Success;
    } catch (e) {
      // 4. Manejar error
      _weather = null;
      _errorMessage = e.toString();
      _state = ViewState.Error;
    } finally {
      // 5. Notificar a la UI del resultado final (éxito o error)
      notifyListeners();
    }
  }
}