import 'package:flutter/material.dart';

// Barra de búsqueda para filtrar empresas
class CompanySearchBar extends StatelessWidget {
  final TextEditingController controller; // Controlador del texto
  final Function(String) onChanged; // Callback al cambiar el texto

  const CompanySearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40, // Altura de la barra
      child: TextField(
        controller: controller,
        onChanged: onChanged, // Ejecuta la funcion al escribir
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: "Buscar empresa...", // Texto de ayuda
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
          filled: true,
          fillColor: const Color(0xFF1B1F23), // Fondo de la barra
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.white, size: 20), // Icono de lupa
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
        ),
      ),
    );
  }
}
