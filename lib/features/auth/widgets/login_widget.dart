import 'package:flutter/material.dart';

// Widget de login
// Contiene campos de email y contraseña, boton de login, manejo de errores y link de olvido contraseña
class LoginWidget extends StatelessWidget {
    final bool isLogin;
    final bool isLoading; 
    final String? errorMessage; 
    final TextEditingController emailController; 
    final TextEditingController passwordController;
    final bool obscurePassword; 

    // Callbacks
    final VoidCallback onLogin; 
    final VoidCallback onForgotPassword;
    final VoidCallback toggleObscurePassword;
    final VoidCallback onSelectLogin;

    const LoginWidget({
        super.key,
        required this.isLogin,
        required this.isLoading,
        required this.errorMessage,
        required this.emailController,
        required this.passwordController,
        required this.obscurePassword,
        required this.onLogin,
        required this.onForgotPassword,
        required this.toggleObscurePassword,
        required this.onSelectLogin,
    });

    @override
    Widget build(BuildContext context) {
        return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
            children: [
                // Selector de tab de login
                Container(
                width: 180,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: const Color(0xFFeeeeee),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                    color: const Color(0xFFeeeeee),
                    width: 0.5,
                    ),
                ),
                child: Row(
                    children: [
                    Expanded(
                        child: GestureDetector(
                        onTap: onSelectLogin,
                        child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                            color: isLogin ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                            "Login",
                            style: TextStyle(
                                color: isLogin ? Colors.black : Colors.grey,
                                fontWeight: FontWeight.w600,
                            ),
                            ),
                        ),
                        ),
                    ),
                    ],
                ),
                ),
                const SizedBox(height: 20),

                // Campo de email
                TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "Correo Electronico",
                    hintStyle: const TextStyle(color: Color(0xFFacacac), fontSize: 14),
                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF085f5d)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: Color(0xFFeeeeee), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: Color(0xFFeeeeee), width: 1.5),
                    ),
                ),
                ),
                const SizedBox(height: 14),

                // Campo de contraseña con visibilidad toggle
                TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                obscuringCharacter: '•',
                decoration: InputDecoration(
                    hintText: "Contraseña",
                    hintStyle: const TextStyle(color: Color(0xFFacacac), fontSize: 14),
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF085f5d)),
                    suffixIcon: IconButton(
                    icon: Icon(
                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black54,
                        size: 20,
                    ),
                    onPressed: toggleObscurePassword,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: Color(0xFFeeeeee), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: const BorderSide(color: Color(0xFFeeeeee), width: 1.5),
                    ),
                ),
                ),

                // Link para olvido contraseña
                Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: onForgotPassword,
                    child: const Text(
                    "Olvido contraseña?",
                    style: TextStyle(color: Color(0xFF085f5d)),
                    ),
                ),
                ),
                const SizedBox(height: 10),

                // Mostrar mensaje de error si existe
                if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 10),

                // Boton de login o indicador de carga
                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                        onPressed: onLogin,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            backgroundColor: const Color(0xFF085f5d),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            ),
                        ),
                        child: const Text(
                            "Iniciar Sesion",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ),
                    ),
            ],
            ),
        ),
        );
    }
}
