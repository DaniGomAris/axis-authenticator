import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';
import 'forget_password_page.dart';
import 'package:axis_authenticator/pages/home_page.dart';
import 'dart:convert';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  bool isLoginVisible = false;
  bool isLogin = true;

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
    emailController.addListener(_clearError);
    passwordController.addListener(_clearError);
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
              builder: (_) => HomePage(token: newToken, user: user),
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
      final user = data["user"];
      await storage.write(key: 'token', value: token);
      await storage.write(key: 'user', value: jsonEncode(user));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(token: token, user: user),
          ),
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
    if (checkingToken) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Fondo negro
          GestureDetector(
            onTap: () {
              if (isLoginVisible) {
                setState(() {
                  isLoginVisible = false;
                });
                FocusScope.of(context).unfocus();
              }
            },
            child: Container(color: const Color(0xFF121416)),
          ),

          // Contenido principal
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
                          padding: const EdgeInsets.symmetric(horizontal: 24)
                              .copyWith(top: 165),
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

          // Recuadro blanco animado
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            left: 0,
            right: 0,
            bottom: isLoginVisible ? 0 : -420,
            height: 390,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Toggle Login
                    Container(
                      width: 180,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFeeeeee),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xFFeeeeee),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => isLogin = true),
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
                    // Email
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email Address",
                        hintStyle: const TextStyle(color: Color(0xFFacacac), fontSize: 14),
                        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF6e947c)),
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
                    // Password
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      obscuringCharacter: '•',
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(color: Color(0xFFacacac), fontSize: 14),
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6e947c)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black54,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ForgetPasswordPage()),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Color(0xFF6e947c)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (errorMessage != null)
                      Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 10),
                    // Botón login
                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                backgroundColor: const Color(0xFF6e947c),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
          // Botón "Get started"
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
                    backgroundColor: const Color(0xFF6e947c),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Get started",
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
