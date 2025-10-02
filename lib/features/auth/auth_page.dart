import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './auth_service.dart';
import '../user/user_service.dart';
import '../companies/companies_page.dart';
import 'dart:convert';
import 'widgets/login_widget.dart';
import 'widgets/forgot_password_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLoginVisible = false;
  bool isLogin = true;
  bool showForgotPassword = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final forgotController = TextEditingController();

  bool isLoading = false;
  bool isSendingOtp = false;
  String? errorMessage;           // solo para login
  String? forgotErrorMessage;     // solo para forgot password
  bool checkingToken = true;

  bool _obscurePassword = true;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    emailController.addListener(_clearLoginError);
    passwordController.addListener(_clearLoginError);
    forgotController.addListener(_clearForgotError);
    _checkToken();
  }

  void _clearLoginError() {
    if (errorMessage != null) {
      setState(() => errorMessage = null);
    }
  }

  void _clearForgotError() {
    if (forgotErrorMessage != null) {
      setState(() => forgotErrorMessage = null);
    }
  }

  Future<void> _checkToken() async {
    final token = await storage.read(key: 'token');
    final userJson = await storage.read(key: 'user');
    if (token != null && userJson != null) {
      try {
        final result = await AuthService.verifyToken(token);
        final valid = result['valid'] as bool;
        final newToken = result['token'] as String;

        if (valid && mounted) {
          if (newToken != token) {
            await storage.write(key: 'token', value: newToken);
          }

          final user = Map<String, dynamic>.from(jsonDecode(userJson));

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
    setState(() => checkingToken = false);
  }

  void _login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() => errorMessage = "Ingrese sus credenciales para iniciar sesión");
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

  void _sendOtp() async {
    if (forgotController.text.trim().isEmpty) {
      setState(() => forgotErrorMessage = "Ingrese su teléfono");
      return;
    }

    setState(() {
      isSendingOtp = true;
      forgotErrorMessage = null;
    });

    try {
      final success = await UserService.sendOtp(forgotController.text.trim());

      if (success && mounted) {
        setState(() => showForgotPassword = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP enviado correctamente")),
        );
      }
    } catch (e) {
      setState(() => forgotErrorMessage = e.toString());
    } finally {
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
    if (checkingToken) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (isLoginVisible || showForgotPassword) {
                setState(() {
                  isLoginVisible = false;
                  showForgotPassword = false;
                });
                FocusScope.of(context).unfocus();
              }
            },
            child: Container(color: const Color(0xFF0b1014)),
          ),

          Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 110,
                  height: 150,
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: isLoginVisible
                      ? Padding(
                          key: const ValueKey("loginText"),
                          padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 165),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Go ahead and set up\nyour account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "\nSign in-up to enjoy the best managing experience",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),

          // LoginWidget
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

          // ForgotPasswordWidget centrado
          if (showForgotPassword)
            Center(
              child: ForgotPasswordWidget(
                controller: forgotController,
                isSendingOtp: isSendingOtp,
                errorMessage: forgotErrorMessage,
                onSendOtp: _sendOtp,
                onCancel: () => setState(() => showForgotPassword = false),
              ),
            ),

          // Botón "Empezar"
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            bottom: isLoginVisible ? -60 : 80,
            left: 24,
            right: 24,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isLoginVisible ? 0 : 1,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() => isLoginVisible = true),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    backgroundColor: const Color(0xFF085f5d),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Empezar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
