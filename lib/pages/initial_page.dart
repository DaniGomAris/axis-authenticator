import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_page.dart';
import '../services/auth_service.dart';
import 'forget_password_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  bool isLoginVisible = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  bool checkingToken = true;

  bool _obscurePassword = true;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    // Limpiar mensaje de error al modificar email o password
    emailController.addListener(_clearError);
    passwordController.addListener(_clearError);

    // Verificar token persistente
    _checkToken();
  }

  void _clearError() {
    if (errorMessage != null) {
      setState(() {
        errorMessage = null;
      });
    }
  }

  Future<void> _checkToken() async {
    final token = await storage.read(key: 'token');
    if (token != null) {
      try {
        final result = await AuthService.verifyToken(token);
        final valid = result['valid'] as bool;
        final newToken = result['token'] as String;

        if (valid && mounted) {
          // Guardar token renovado si es distinto
          if (newToken != token) {
            await storage.write(key: 'token', value: newToken);
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage(token: newToken)),
          );
          return;
        } else {
          await storage.delete(key: 'token');
        }
      } catch (_) {
        await storage.delete(key: 'token');
      }
    }
    setState(() {
      checkingToken = false;
    });
  }

  void _login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() {
        errorMessage = "Enter your credentials to log in";
      });
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

      // Guardar token para persistencia
      await storage.write(key: 'token', value: token);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(token: token)),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mostrar un loader mientras se verifica token
    if (checkingToken) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (isLoginVisible) {
            setState(() {
              isLoginVisible = false;
            });
            FocusScope.of(context).unfocus();
          }
        },
        child: Stack(
          children: [
            // Fondo degradado
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF000000),
                    Color(0xFF0f0f0f),
                    Color(0xFF000000),
                  ],
                ),
              ),
            ),

            // Logo animado
            SafeArea(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                alignment: isLoginVisible
                    ? const Alignment(0, -0.7)
                    : Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),

            // Botón "Log in"
            if (!isLoginVisible)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isLoginVisible = true;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Log in",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final textWidth = (TextPainter(
                                    text: const TextSpan(
                                        text: "Log in",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    maxLines: 1,
                                    textDirection: TextDirection.ltr)
                                  ..layout())
                                .size
                                .width;
                            return Container(
                              width: textWidth,
                              height: 2,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Recuadro de login
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              bottom: 0,
              left: 0,
              right: 0,
              height: isLoginVisible ? 300 : 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF161616),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: const TextStyle(color: Colors.white70),
                            floatingLabelStyle: const TextStyle(
                                color: Colors.white, fontSize: 12),
                            filled: true,
                            fillColor: const Color(0xFF161616),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: const BorderSide(
                                  color: Color(0xFF4D4D4D), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: const BorderSide(
                                  color: Color(0xFFB3FFFFFF)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          obscuringCharacter: '•',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.white70),
                            floatingLabelStyle: const TextStyle(
                                color: Colors.white, fontSize: 12),
                            filled: true,
                            fillColor: const Color(0xFF161616),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: const BorderSide(
                                  color: Color(0xFF4D4D4D), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: const BorderSide(
                                  color: Color(0xFFB3FFFFFF)),
                            ),
                            suffixIcon: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgetPasswordPage()),
                              );
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: Colors.white70,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (errorMessage != null)
                          Text(errorMessage!,
                              style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 10),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 100, vertical: 16),
                                  backgroundColor: const Color(0xFF0048C5),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
