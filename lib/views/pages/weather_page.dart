// lib/views/pages/weather_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/weather_model.dart';
import '../../viewmodels/weather_viewmodel.dart';

// 1. Convertimos la página a un StatefulWidget
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // 2. Declaramos el controlador como una propiedad de la clase State.
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    // 3. Lo inicializamos una sola vez.
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    // 4. Liberamos su memoria cuando el widget se destruye.
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el ViewModel como siempre.
    final viewModel = context.watch<WeatherViewModel>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  // 5. Usamos el controlador persistente del estado.
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'Ciudad',
                    hintText: 'Ej: Quito, Guayaquil',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (city) {
                    if (city.isNotEmpty) {
                      context.read<WeatherViewModel>().fetchWeather(city);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: const Icon(Icons.search),
                iconSize: 30,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  final city = _cityController.text;
                  if (city.isNotEmpty) {
                    context.read<WeatherViewModel>().fetchWeather(city);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _buildBody(context, viewModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel viewModel) {
    switch (viewModel.state) {
      case ViewState.Loading:
        return const Center(key: ValueKey('loading'), child: CircularProgressIndicator());
      case ViewState.Success:
        return _WeatherSuccessView(key: const ValueKey('success'), weather: viewModel.weather!);
      case ViewState.Error:
        return _ErrorView(key: const ValueKey('error'), message: viewModel.errorMessage);
      case ViewState.Idle:
      default:
        return const _IdleView(key: ValueKey('idle'));
    }
  }
}

// --- El resto de los widgets de estado no necesitan cambios ---

class _IdleView extends StatelessWidget {
  const _IdleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wb_sunny_outlined, size: 80, color: Colors.orange.shade300),
        const SizedBox(height: 16),
        Text(
          'Ingresa una ciudad para ver el clima',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({super.key, required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
        const SizedBox(height: 16),
        Text(
          '¡Ups! Ocurrió un error',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _WeatherSuccessView extends StatelessWidget {
  const _WeatherSuccessView({super.key, required this.weather});
  final Weather weather;

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds': return Icons.cloud;
      case 'rain': return Icons.umbrella;
      case 'clear': return Icons.wb_sunny;
      case 'snow': return Icons.ac_unit;
      case 'thunderstorm': return Icons.flash_on;
      default: return Icons.cloud_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(weather.cityName, style: textTheme.displaySmall),
            const SizedBox(height: 8),
            Icon(
              _getWeatherIcon(weather.condition),
              size: 100,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              '${weather.temperature.round()}°C',
              style: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              weather.description,
              style: textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}