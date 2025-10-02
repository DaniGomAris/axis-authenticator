import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

// Widget que muestra un codigo de barras del usuario
class UserBarcode extends StatelessWidget {
    final String userId; // ID del usuario que se codifica

    const UserBarcode({super.key, required this.userId});

    @override
    Widget build(BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;

        return Positioned(
        // Posiciona el codigo de barras centrado horizontalmente y a 820px vertical
        top: 820,
        left: screenWidth / 2 - 150, // Centrado con width 300
        child: BarcodeWidget(
            barcode: Barcode.code128(), // Tipo de codigo de barras
            data: userId, // Datos a codificar
            width: 300,
            height: 50,
            drawText: false, // No dibujar el texto debajo del codigo
            color: Colors.black,
        ),
        );
    }
}
