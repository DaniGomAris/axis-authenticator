import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './auth_service.dart';
import '../user/user_service.dart';
import '../companies/companies_page.dart';
import 'dart:convert';
import 'widgets/login_widget.dart';
import 'widgets/forgot_password_widget.dart';
import 'widgets/auth_background.dart';
import 'widgets/logo_widget.dart';
import 'widgets/auth_title.dart';
import 'widgets/primary_button.dart';

// Pagina principal de autenticacion
// Maneja login, verificacion de token y olvido de contraseña
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Estado de visibilidad de widgets
  bool isLoginVisible = false;
  bool isLogin = true;
  bool showForgotPassword = false;

  // Controladores de texto
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final forgotController = TextEditingController();

  // Estado de carga y errores
  bool isLoading = false;
  bool isSendingOtp = false;
  String? errorMessage;
  bool checkingToken = true;

  bool _obscurePassword = true; // Ocultar/mostrar contraseña
  final storage = const FlutterSecureStorage(); // Almacenamiento seguro local

  @override
  void initState() {
    super.initState();
    // Limpiar errores cuando cambian los campos
    emailController.addListener(_clearError);
    passwordController.addListener(_clearError);
    forgotController.addListener(_clearError);
    _checkToken(); // Verificar token guardado al iniciar
  }

  // Limpia mensaje de error
  void _clearError() {
    if (errorMessage != null) {
      setState(() => errorMessage = null);
    }
  }

  // Verifica si ya existe un token valido en almacenamiento seguro
  Future<void> _checkToken() async {
    final token = await storage.read(key: 'token');
    final userJson = await storage.read(key: 'user');

    if (token != null && userJson != null) {
      try {
        final result = await AuthService.verifyToken(token);
        final valid = result['valid'] as bool;
        final newToken = result['token'] as String;

        if (valid && mounted) {
          // Actualiza token si cambió
          if (newToken != token) await storage.write(key: 'token', value: newToken);
          final user = Map<String, dynamic>.from(jsonDecode(userJson));

          // Redirige a la pagina de empresas
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => CompaniesPage(token: newToken, user: user),
            ),
          );
          return;
        } else {
          await storage.delete(key: 'token');
          await storage.delete(key: 'user');
        }
      } catch (_) {
        await storage.delete(key: 'token');
        await storage.delete(key: 'user');
      }
    }
    setState(() => checkingToken = false); // Ya se verifico token
  }

  // Maneja login con email y contraseña
  void _login() async {
    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      setState(() => errorMessage = "Ingrese sus credenciales para iniciar sesion");
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final data = await AuthService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final token = data["token"];
      final user = data["user"];
      await storage.write(key: 'token', value: token);
      await storage.write(key: 'user', value: jsonEncode(user));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => CompaniesPage(token: token, user: user),
          ),
        );
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Envia OTP para recuperar contraseña
  void _sendOtp() async {
    if (forgotController.text.trim().isEmpty) return;

    setState(() => isSendingOtp = true);

    try {
      final success = await UserService.sendOtp(forgotController.text.trim());
      if (success && mounted) setState(() => showForgotPassword = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP enviado correctamente")),
      );
    } catch (_) {} finally {
      setState(() => isSendingOtp = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    forgotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Muestra loader mientras se verifica token
    if (checkingToken) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: AuthBackground(
        onTapOutside: () {
          // Cierra login o forgot password al tocar fuera
          if (isLoginVisible || showForgotPassword) {
            setState(() {
              isLoginVisible = false;
              showForgotPassword = false;
            });
            FocusScope.of(context).unfocus();
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                const LogoWidget(width: 110, height: 150), // Logo superior
                Expanded(
                  child: AuthTitle(isLoginVisible: isLoginVisible), // Texto animado
                ),
              ],
            ),

            // Login widget animado desde abajo
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              bottom: isLoginVisible ? 0 : -420,
              height: 390,
              child: LoginWidget(
                isLogin: isLogin,
                isLoading: isLoading,
                errorMessage: errorMessage,
                emailController: emailController,
                passwordController: passwordController,
                obscurePassword: _obscurePassword,
                onLogin: _login,
                onForgotPassword: () => setState(() => showForgotPassword = true),
                toggleObscurePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                onSelectLogin: () => setState(() => isLogin = true),
              ),
            ),

            // Forgot Password centrado
            if (showForgotPassword)
              Center(
                child: ForgotPasswordWidget(
                  controller: forgotController,
                  isSendingOtp: isSendingOtp,
                  onSendOtp: _sendOtp,
                  onCancel: () => setState(() => showForgotPassword = false),
                ),
              ),

            // Boton "Empezar" animado
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOut,
              bottom: isLoginVisible ? -60 : 80,
              left: 24,
              right: 24,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLoginVisible ? 0 : 1,
                child: PrimaryButton(
                  text: "Empezar",
                  onPressed: () => setState(() => isLoginVisible = true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } 
}
