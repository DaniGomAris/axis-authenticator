import 'package:flutter/material.dart';
import 'package:axis_authenticator/features/auth/auth_service.dart';
import 'package:axis_authenticator/features/auth/auth_page.dart';

class CustomSideMenu extends StatefulWidget {
  final Widget child;
  final double menuWidth;
  final String token;

  const CustomSideMenu({
    super.key,
    required this.child,
    required this.token,
    this.menuWidth = 250,
  });

  @override
  State<CustomSideMenu> createState() => _CustomSideMenuState();
}

class _CustomSideMenuState extends State<CustomSideMenu> {
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService.logout(widget.token);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenido principal
        widget.child,

        // Botón hamburguesa arriba a la derecha
        Positioned(
          top: 50,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: _toggleMenu,
          ),
        ),

        // Overlay oscuro para cerrar tocando fuera
        if (_isMenuOpen)
          GestureDetector(
            onTap: _toggleMenu,
            child: Container(
              color: Colors.black54,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

        // Menú deslizable (desde la derecha)
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          top: 0,
          bottom: 0,
          right: _isMenuOpen ? 0 : -widget.menuWidth,
          width: widget.menuWidth,
          child: Material(
            elevation: 8,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            color: const Color(0xFF25292e),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Items del menú
                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.white),
                    title: const Text("Inicio",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      // Acción al ir a inicio
                      _toggleMenu();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white),
                    title: const Text("Configuracion",
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      _toggleMenu();
                    },
                  ),

                  const Spacer(),

                  // Botón cerrar sesion
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF085f5d),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        "Cerrar sesión",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
