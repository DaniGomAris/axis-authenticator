import 'package:flutter/material.dart';

// Widget que muestra la informacion del usuario: nombre completo y ID
class QRUserInfo extends StatelessWidget {
    final Map<String, dynamic> user; // Datos del usuario

    const QRUserInfo({super.key, required this.user});

    @override
    Widget build(BuildContext context) {
        // Construye el nombre completo combinando los campos disponibles
        final fullName =
            "${user['name'] ?? ''} ${user['last_name1'] ?? ''} ${user['last_name2'] ?? ''}".trim();
        final userId = user['_id'] ?? '';

        return Column(
        children: [
            // Nombre completo
            Text(
            fullName,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            // Identificacion del usuario
            Text(
            "CC: $userId",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
            ),
            textAlign: TextAlign.center,
            ),
        ],
        );
    }
}
