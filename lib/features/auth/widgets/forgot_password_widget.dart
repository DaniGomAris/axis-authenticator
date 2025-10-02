import 'package:flutter/material.dart';

// Widget para la funcionalidad de "Olvide contraseña"
// Permite ingresar telefono, enviar OTP y cancelar
class ForgotPasswordWidget extends StatefulWidget {
    final TextEditingController controller; // Controlador del input de telefono
    final bool isSendingOtp; // Indica si se esta enviando OTP
    final VoidCallback onSendOtp; // Callback al enviar OTP
    final VoidCallback onCancel; // Callback al cancelar

    ForgotPasswordWidget({
        super.key,
        required this.controller,
        required this.isSendingOtp,
        required this.onSendOtp,
        required this.onCancel,
    });

    @override
    State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
    String? errorMessage; // Mensaje de error al validar input

    // Limpia el mensaje de error al cambiar el texto
    void _clearError() {
        if (errorMessage != null) {
        setState(() {
            errorMessage = null;
        });
        }
    }

    @override
    void initState() {
        super.initState();
        // Escucha cambios en el TextField para limpiar errores
        widget.controller.addListener(_clearError);
    }

    @override
    Widget build(BuildContext context) {
        return Container(
        width: 350,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
            ),
            ],
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            // Titulo del widget
            const Text(
                "Olvide contraseña",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Input de telefono
            TextField(
                controller: widget.controller,
                decoration: InputDecoration(
                hintText: "Ingrese su numero de telefono",
                filled: true,
                fillColor: const Color(0xFFf5f5f5),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                ),
                ),
            ),
            const SizedBox(height: 10),

            // Mostrar mensaje de error si existe
            if (errorMessage != null)
                Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
            const SizedBox(height: 20),

            // Boton para enviar OTP o indicador de carga
            widget.isSendingOtp
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () {
                        // Validar que el campo no este vacio
                        if (widget.controller.text.trim().isEmpty) {
                        setState(() {
                            errorMessage = "Ingrese su telefono";
                        });
                        return;
                        }
                        // Llamar callback para enviar OTP
                        widget.onSendOtp();
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF085f5d),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        ),
                    ),
                    child: const Text(
                        "Enviar SMS",
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        ),
                    ),
                    ),
            const SizedBox(height: 15),

            // Boton para cancelar la accion
            OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFeeeeee), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                child: const Text(
                "Cancelar",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                ),
                ),
            ),
            ],
        ),
        );
    }
}
