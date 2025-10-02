import 'package:flutter/material.dart';

// Widget que proporciona un fondo uniforme para pantallas de autenticacion
// Permite detectar taps fuera de los campos a traves de onTapOutside
class AuthBackground extends StatelessWidget {
    final Widget child; // Contenido principal que se coloca encima del fondo
    final VoidCallback? onTapOutside; // Callback cuando se toca fuera del child

    const AuthBackground({
        super.key,
        required this.child,
        this.onTapOutside,
    });

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
        onTap: onTapOutside, // Ejecuta la accion si se toca fuera
        child: Container(
            color: const Color(0xFF0b1014), // Color de fondo uniforme
            child: child, // Contenido de la pantalla
        ),
        );
    }
}
