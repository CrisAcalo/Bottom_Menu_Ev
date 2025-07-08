// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = 'e79e4f0203a230e855dd04babddad4a5';

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? queryParams}) async {
    final query = {
      'appid': _apiKey,
      'lang': 'es',
      'units': 'metric' // Esto hace que la temperatura venga en Celsius directamente
    };

    if (queryParams != null) {
      query.addAll(queryParams);
    }

    final uri = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: query);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error en la API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Fallo al conectar con el servicio: $e');
    }
  }
}