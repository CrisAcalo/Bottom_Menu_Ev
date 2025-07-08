import '../models/weather_model.dart';
import '../services/api_service.dart';

class WeatherRepository {
  final ApiService _apiService = ApiService();

  Future<Weather> fetchWeather(String city) async {
    try {

       final Map<String, dynamic> jsonData = await _apiService.get(
        'weather',
        queryParams: {'q': city},
      );

      return Weather.fromJson(jsonData);

    } catch (e) {
      print('Error en WeatherRepository: $e'); // Para depuración en la consola.

      throw Exception('No se pudo obtener el clima. Verifica el nombre de la ciudad y tu conexión.');
    }
  }
}