import 'package:flutter/material.dart';

// Barra superior que muestra el nombre de la empresa o rol del usuario
// con botones para alternar entre ambos
class QRToggleBar extends StatelessWidget {
    final bool showCompanyName; // Si se muestra el nombre de la empresa o el rol
    final String companyName; // Nombre de la empresa
    final String userRole; // Rol del usuario
    final VoidCallback onToggle; // Funcion que se llama al presionar los botones

    const QRToggleBar({
        super.key,
        required this.showCompanyName,
        required this.companyName,
        required this.userRole,
        required this.onToggle,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
        height: 60,
        decoration: BoxDecoration(
            color: const Color(0xFF085f5d),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
            ),
            ],
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            // Boton para alternar hacia la izquierda
            IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                onPressed: onToggle,
            ),
            // Texto central que cambia entre empresa y rol
            Text(
                showCompanyName ? companyName : userRole,
                style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                ),
            ),
            // Boton para alternar hacia la derecha
            IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white, size: 30),
                onPressed: onToggle,
            ),
            ],
        ),
        );
    }
}
