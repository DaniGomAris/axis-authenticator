import 'package:flutter/material.dart';

// Barra superior con titulo fijo, alineado a la izquierda
class TopBar extends StatelessWidget {
    final String title; // Texto a mostrar en la barra

    const TopBar({super.key, required this.title});

    @override
    Widget build(BuildContext context) {
        return Align(
        alignment: Alignment.centerLeft, // Alinea el titulo a la izquierda
        child: Text(
            title,
            style: const TextStyle(
            color: Color(0xFF085f5d),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            ),
        ),
        );
    }
}
