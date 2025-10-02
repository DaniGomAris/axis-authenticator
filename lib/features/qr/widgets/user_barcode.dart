import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';

// Widget que genera un codigo de barras para el usuario
class UserBarcode extends StatelessWidget {
    final String userId; // ID del usuario que se codifica en el barcode

    const UserBarcode({super.key, required this.userId});

    @override
    Widget build(BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;

        return Positioned(
        // Posiciona el barcode centrado horizontalmente y a 820 de la parte superior
        top: 820,
        left: screenWidth / 2 - 150,
        child: BarcodeWidget(
            barcode: Barcode.code128(), // Tipo de codigo de barras
            data: userId, // Contenido del barcode
            width: 300,
            height: 50,
            drawText: false, // No dibuja el texto debajo del barcode
            color: Colors.black,
        ),
        );
    }
}
