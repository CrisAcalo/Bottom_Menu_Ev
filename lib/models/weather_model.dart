class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String condition;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.condition,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      // La temperatura ya viene en Celsius gracias a 'units=metric' en la llamada API.
      // Lo convertimos a double por si viene como entero.
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'],
      condition: json['weather'][0]['main'],
    );
  }
}