import 'package:flutter/material.dart';

// Barra de progreso que muestra visualmente el avance de generacion del QR
class QRProgressBar extends StatelessWidget {
    final double progress; // Progreso entre 0 y 1

    const QRProgressBar({super.key, required this.progress});

    @override
    Widget build(BuildContext context) {
        return Container(
        height: 3, // Altura de la barra
        width: 220, // Ancho total de la barra
        decoration: BoxDecoration(
            color: const Color(0xFF25292e), // Color de fondo de la barra
            borderRadius: BorderRadius.circular(30), // Bordes redondeados
        ),
        child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
            widthFactor: progress, // Ancho proporcional al progreso
            child: Container(
                decoration: BoxDecoration(
                color: const Color(0xFF085f5d), // Color del progreso
                borderRadius: BorderRadius.circular(30),
                ),
            ),
            ),
        ),
        );
    }
}
