import 'package:flutter/material.dart';
import 'features/auth/auth_page.dart';

void main() {
  // Punto de entrada de la aplicacion
  runApp(const MyApp());
}

// Widget principal de la aplicacion
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de debug
      title: 'Axis Authenticator', // Titulo de la aplicacion
      theme: ThemeData(
        // Color primario de la aplicacion (puede cambiarse a un verde personalizado para coincidir con QRPage)
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF0b1014), // Color de fondo global
        // Estilos de texto globales (opcional)
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        // Color de iconos por defecto
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: const AuthPage(), // Pantalla inicial de autenticacion
    );
  }
}
