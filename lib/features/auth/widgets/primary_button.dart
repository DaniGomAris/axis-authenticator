import 'package:flutter/material.dart';

// Boton primario reutilizable de la app
// Ocupa todo el ancho disponible y permite definir el texto y la accion al presionar
class PrimaryButton extends StatelessWidget {
    final String text; // Texto que se muestra en el boton
    final VoidCallback onPressed; // Funcion que se ejecuta al presionar el boton

    const PrimaryButton({super.key, required this.text, required this.onPressed});

    @override
    Widget build(BuildContext context) {
        return SizedBox(
        width: double.infinity, // Ocupa todo el ancho disponible
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20), // Altura del boton
            backgroundColor: const Color(0xFF085f5d), // Color de fondo
            foregroundColor: Colors.white, // Color del texto
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)), // Bordes redondeados
            ),
            child: Text(
            text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
        ),
        );
    }
}
