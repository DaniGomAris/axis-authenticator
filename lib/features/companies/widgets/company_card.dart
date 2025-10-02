import 'package:flutter/material.dart';

// Tarjeta individual de una empresa con icono
class CompanyCard extends StatelessWidget {
    final Map<String, dynamic> company; // Datos de la empresa
    final VoidCallback onTap; // Callback al tocar la tarjeta

    const CompanyCard({
        super.key,
        required this.company,
        required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
        onTap: onTap, // Ejecuta la accion al tocar la tarjeta
        child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
            color: const Color(0xFF25292e), // Fondo de la tarjeta
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
            boxShadow: [
                BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 4), // Sombra debajo de la tarjeta
                ),
            ],
            ),
            child: Row(
            children: [
                // Icono de empresa al inicio
                Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: const Color(0xFF085f5d),
                    shape: BoxShape.circle,
                ),
                child: const Icon(Icons.business, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12), // Separacion entre icono y nombre
                // Nombre de la empresa
                Expanded(
                child: Text(
                    company['name'],
                    style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    ),
                ),
                ),
                // Icono de flecha indicando accion
                const Icon(
                Icons.arrow_forward,
                color: Color(0xFF085f5d),
                size: 22,
                ),
            ],
            ),
        ),
        );
    }
}
