import 'package:flutter/material.dart';

// Widget que muestra el titulo de la pantalla de autenticacion
// Cambia entre login visible o no con animacion suave
class AuthTitle extends StatelessWidget {
    final bool isLoginVisible; // Indica si se debe mostrar el titulo de login

    const AuthTitle({super.key, required this.isLoginVisible});

    @override
    Widget build(BuildContext context) {
        return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200), // Duracion de la animacion
        transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation, // Transicion de opacidad
            child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
                .animate(animation), // Deslizamiento de abajo hacia arriba
            child: child,
            ),
        ),
        child: isLoginVisible
            ? Padding(
                key: const ValueKey("loginText"), // Identificador para AnimatedSwitcher
                padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 165),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                    Text(
                        "Tu acceso seguro, \nlisto para usar", // Titulo principal
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                        ),
                    ),
                    SizedBox(height: 6),
                    Text(
                        "\nTu llave digital siempre a la mano", // Subtitulo
                        style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        height: 1.4,
                        ),
                    ),
                    ],
                ),
                )
            : const SizedBox.shrink(), // No mostrar nada si login no es visible
        );
    }
}
