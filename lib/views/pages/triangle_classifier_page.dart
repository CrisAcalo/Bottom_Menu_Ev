// lib/views/pages/triangle_classifier_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/triangle_model.dart';
import '../../viewmodels/triangle_classifier_viewmodel.dart';

// 1. Convertimos el widget a StatefulWidget
class TriangleClassifierPage extends StatefulWidget {
  const TriangleClassifierPage({super.key});

  @override
  State<TriangleClassifierPage> createState() => _TriangleClassifierPageState();
}

class _TriangleClassifierPageState extends State<TriangleClassifierPage> {
  // 2. Declaramos los controllers como propiedades de la clase State.
  //    'late final' significa que se inicializarán una vez y no cambiarán.
  late final TextEditingController _sideAController;
  late final TextEditingController _sideBController;
  late final TextEditingController _sideCController;

  @override
  void initState() {
    super.initState();
    // 3. Inicializamos los controllers UNA SOLA VEZ cuando el widget se crea.
    _sideAController = TextEditingController();
    _sideBController = TextEditingController();
    _sideCController = TextEditingController();
  }

  @override
  void dispose() {
    // 4. MUY IMPORTANTE: Liberamos la memoria de los controllers cuando el widget se destruye.
    _sideAController.dispose();
    _sideBController.dispose();
    _sideCController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // El ViewModel se sigue obteniendo de la misma manera.
    final viewModel = context.watch<TriangleClassifierViewModel>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // 5. Usamos los controllers que son parte del estado del widget.
            _SideTextField(controller: _sideAController, label: 'Lado A'),
            const SizedBox(height: 16),
            _SideTextField(controller: _sideBController, label: 'Lado B'),
            const SizedBox(height: 16),
            _SideTextField(controller: _sideCController, label: 'Lado C'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                // Ahora siempre leerá de los controllers correctos y persistentes.
                context.read<TriangleClassifierViewModel>().classifyTriangle(
                  _sideAController.text,
                  _sideBController.text,
                  _sideCController.text,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Clasificar Triángulo'),
            ),
            const SizedBox(height: 40),

            _ResultDisplay(triangleType: viewModel.triangleType),
          ],
        ),
      ),
    );
  }
}

// El resto de los widgets (_SideTextField, _ResultDisplay) no necesitan cambios.
// Los copio aquí por completitud.

class _SideTextField extends StatelessWidget {
  const _SideTextField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
    );
  }
}

class _ResultDisplay extends StatelessWidget {
  const _ResultDisplay({required this.triangleType});

  final TriangleType triangleType;

  @override
  Widget build(BuildContext context) {
    Widget content;
    final textTheme = Theme.of(context).textTheme;

    switch (triangleType) {
      case TriangleType.Equilatero:
        content = _buildResultCard(
          context,
          icon: Icons.check_circle,
          color: Colors.green,
          title: 'Equilátero',
          subtitle: 'Todos los lados son iguales.',
        );
        break;
      case TriangleType.Isosceles:
        content = _buildResultCard(
          context,
          icon: Icons.check_circle_outline,
          color: Colors.blue,
          title: 'Isósceles',
          subtitle: 'Dos lados son iguales.',
        );
        break;
      case TriangleType.Escaleno:
        content = _buildResultCard(
          context,
          icon: Icons.check_circle_outline,
          color: Colors.orange,
          title: 'Escaleno',
          subtitle: 'Todos los lados son diferentes.',
        );
        break;
      case TriangleType.Invalido:
        content = _buildResultCard(
          context,
          icon: Icons.error,
          color: Colors.red,
          title: 'Inválido',
          subtitle: 'Los lados ingresados no pueden formar un triángulo.',
        );
        break;
      case TriangleType.Inicial:
        content = Column(
          children: [
            const Icon(Icons.info_outline, size: 40, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              'Ingresa los tres lados para comenzar.',
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        );
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: content,
    );
  }

  Widget _buildResultCard(BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      key: ValueKey(title),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 12),
            Text(title, style: textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: textTheme.bodyLarge, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}