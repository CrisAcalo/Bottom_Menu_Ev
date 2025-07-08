// lib/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/bottom_nav_viewmodel.dart';

import 'pages/age_calculator_page.dart';
import 'pages/triangle_classifier_page.dart';
import 'pages/weather_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  // Lista de las páginas que se mostrarán en el cuerpo de la app.
  // El orden debe coincidir con el de los items de la barra de navegación.
  final List<Widget> _pages = const [
    AgeCalculatorPage(),
    TriangleClassifierPage(),
    WeatherPage(),
  ];

  // Lista de los títulos para la AppBar.
  final List<String> _pageTitles = const [
    'Calculadora de Edad',
    'Clasificador de Triángulos',
    'Clima Actual',
  ];

  @override
  Widget build(BuildContext context) {
    // Usamos context.watch para obtener la instancia del ViewModel y
    // para que este widget se reconstruya automáticamente cuando cambie.
    final navViewModel = context.watch<BottomNavViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[navViewModel.currentIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: _pages[navViewModel.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // El índice actual se obtiene directamente del ViewModel.
        currentIndex: navViewModel.currentIndex,
        // La acción onTap llama al método del ViewModel para cambiar el estado.
        onTap: (index) => navViewModel.onPageChanged(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cake_outlined),
            activeIcon: Icon(Icons.cake),
            label: 'Edad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.change_history_outlined),
            activeIcon: Icon(Icons.change_history),
            label: 'Triángulo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_outlined),
            activeIcon: Icon(Icons.cloud),
            label: 'Clima',
          ),
        ],
      ),
    );
  }
}