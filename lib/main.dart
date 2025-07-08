import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'viewmodels/age_calculator_viewmodel.dart';
import 'viewmodels/bottom_nav_viewmodel.dart';
import 'viewmodels/triangle_classifier_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';

// Importamos la vista principal
import 'views/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider es un widget que nos permite proveer múltiples objetos
    // ChangeNotifier (nuestros ViewModels) al árbol de widgets.
    return MultiProvider(
      providers: [
        // 1. Proveedor para la navegación inferior.
        ChangeNotifierProvider(create: (_) => BottomNavViewModel()),

        // 2. Proveedor para la calculadora de edad.
        ChangeNotifierProvider(create: (_) => AgeCalculatorViewModel()),

        // 3. Proveedor para el clasificador de triángulos.
        ChangeNotifierProvider(create: (_) => TriangleClassifierViewModel()),

        // 4. Proveedor para la vista del clima.
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
      ],
      // El hijo de MultiProvider (y todos sus descendientes) tendrán acceso
      // a las instancias de los ViewModels que hemos creado.
      child: MaterialApp(
        title: 'Proyecto Flutter',
        debugShowCheckedModeBanner: false, // Quita la cinta de "Debug"
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,

        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // Inglés
          Locale('es', ''), // Español
        ],
        // La pantalla de inicio de nuestra aplicación.
        home: const HomeView(),
      ),
    );
  }
}