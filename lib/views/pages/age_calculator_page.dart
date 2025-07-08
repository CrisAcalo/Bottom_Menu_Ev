// lib/views/pages/age_calculator_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha

import '../../viewmodels/age_calculator_viewmodel.dart';

class AgeCalculatorPage extends StatelessWidget {
  const AgeCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos context.watch para escuchar los cambios en el ViewModel.
    final viewModel = context.watch<AgeCalculatorViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Muestra la fecha seleccionada o un texto por defecto.
            Text(
              'Tu fecha de nacimiento:',
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              // Usamos el paquete intl para formatear la fecha de forma bonita.
              viewModel.selectedDate == null
                  ? 'No seleccionada'
                  : DateFormat.yMMMMd('es_ES').format(viewModel.selectedDate!),
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Botón para abrir el selector de fecha.
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Seleccionar Fecha'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                // Muestra el diálogo para seleccionar la fecha.
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: viewModel.selectedDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  locale: const Locale('es', 'ES'), // Para que el calendario esté en español.
                );

                if (pickedDate != null) {
                  // Si el usuario seleccionó una fecha, se la pasamos al ViewModel.
                  // Usamos context.read aquí porque estamos dentro de un callback (onPressed)
                  // y no necesitamos que este widget se reconstruya, solo queremos llamar a un método.
                  context.read<AgeCalculatorViewModel>().updateAndCalculateAge(pickedDate);
                }
              },
            ),
            const SizedBox(height: 48),

            // Muestra el resultado solo si ya se ha calculado.
            if (viewModel.ageResult != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Tienes:',
                        style: textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      _ResultRow(
                        value: viewModel.ageResult!.years.toString(),
                        label: 'Años',
                      ),
                      _ResultRow(
                        value: viewModel.ageResult!.months.toString(),
                        label: 'Meses',
                      ),
                      _ResultRow(
                        value: viewModel.ageResult!.days.toString(),
                        label: 'Días',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Un pequeño widget reutilizable para mostrar cada línea del resultado.
class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: textTheme.displaySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Text(label, style: textTheme.headlineSmall),
        ],
      ),
    );
  }
}