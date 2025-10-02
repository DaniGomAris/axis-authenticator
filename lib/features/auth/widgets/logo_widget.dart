import 'package:flutter/material.dart';

// Widget para mostrar el logo de la app
// Permite definir ancho y alto del logo de forma flexible
class LogoWidget extends StatelessWidget {
    final double width; // Ancho del logo
    final double height; // Alto del logo

    const LogoWidget({super.key, required this.width, required this.height});

    @override
    Widget build(BuildContext context) {
        return Align(
        alignment: Alignment.topCenter, // Centrado horizontal en la parte superior
        child: Image.asset(
            'assets/images/logo.png',
            width: width,
            height: height,
        ),
        );
    }
}
