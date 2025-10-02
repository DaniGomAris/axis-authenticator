import 'package:flutter/material.dart';

// Widget para mostrar un estado vacio cuando no hay datos
class EmptyState extends StatelessWidget {
    final String message; // Mensaje a mostrar

    const EmptyState({super.key, required this.message});

    @override
    Widget build(BuildContext context) {
        return Center(
        child: Column(
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
            children: [
            // Icono representativo del estado vacio
            const Icon(Icons.business_outlined, size: 60, color: Colors.white38),
            const SizedBox(height: 10),
            // Mensaje de texto centrado
            Text(
                message,
                style: const TextStyle(color: Colors.white54, fontSize: 16),
                textAlign: TextAlign.center,
            ),
            ],
        ),
        );
    }
}
