import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Widget que muestra un QR dentro de una tarjeta con borde redondeado
// Permite generar un QR nuevo si no existe o mientras se carga muestra un loader
class QRCard extends StatelessWidget {
    final String? qrValue; // Valor a codificar en el QR, null si no generado
    final bool isLoading; // Indicador de carga mientras se genera el QR
    final VoidCallback onGenerate; // Callback al presionar generar QR

    const QRCard({
        super.key,
        required this.qrValue,
        required this.isLoading,
        required this.onGenerate,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
        width: 350,
        height: 350,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(55),
            boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
            ),
            ],
        ),
        child: qrValue != null
            // Si ya existe el valor del QR, mostrar QR normal
            ? Center(
                child: QrImageView(
                    data: qrValue!,
                    version: QrVersions.auto,
                    size: 310,
                ),
                )
            // Si no existe, mostrar QR borroso con boton para generar
            : Stack(
                alignment: Alignment.center,
                children: [
                    // QR borroso de placeholder
                    ClipRRect(
                    borderRadius: BorderRadius.circular(55),
                    child: Stack(
                        children: [
                        QrImageView(
                            data: "placeholder-qr",
                            version: QrVersions.auto,
                            size: 350,
                            foregroundColor: Colors.grey[400],
                        ),
                        Positioned.fill(
                            child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(color: Colors.white.withOpacity(0)),
                            ),
                        ),
                        ],
                    ),
                    ),
                    // Boton circular para generar QR
                    InkWell(
                    onTap: isLoading ? null : onGenerate,
                    borderRadius: BorderRadius.circular(60),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        SizedBox(
                            width: 70,
                            height: 70,
                            child: Center(
                            child: isLoading
                                ? const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 5,
                                        color: Color(0xFF085f5d),
                                    ),
                                    )
                                : const Icon(
                                    Icons.autorenew,
                                    size: 50,
                                    color: Colors.black,
                                    ),
                            ),
                        ),
                        ],
                    ),
                    ),
                ],
                ),
        );
    }
}
