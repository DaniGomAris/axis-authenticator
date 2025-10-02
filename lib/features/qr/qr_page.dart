import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../core/utils/constants.dart';
import 'widgets/qr_card.dart';
import 'widgets/qr_progress_bar.dart';
import 'widgets/qr_user_info.dart';
import 'widgets/qr_toggle_bar.dart';
import 'widgets/user_barcode.dart';

// Pantalla de generacion y visualizacion de QR
class QRPage extends StatefulWidget {
  final String token; // Token de autenticacion del usuario
  final Map<String, dynamic> user; // Datos del usuario
  final Map<String, dynamic> company; // Empresa seleccionada

  const QRPage({
    super.key,
    required this.token,
    required this.user,
    required this.company,
  });

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  String? qrValue; // Valor actual del QR
  bool isLoading = false; // Indica si se esta generando un QR
  Timer? progressTimer; // Temporizador para la expiracion del QR
  double progress = 1.0; // Progreso de la barra (0.0 a 1.0)
  bool showCompanyName = true; // Alterna entre mostrar nombre de empresa o rol del usuario
  String? errorMessage; // Mensaje de error temporal

  // Muestra un mensaje temporal en pantalla
  void _showTemporaryMessage(String message) {
    setState(() => errorMessage = message);
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => errorMessage = null);
    });
  }

  // Maneja el boton de volver
  void _handleBackAction() {
    if (qrValue != null) {
      // Evita salir si hay un QR activo
      _showTemporaryMessage("No puedes salir hasta que el QR expire");
    } else {
      Navigator.pop(context);
    }
  }

  // Genera un QR llamando al backend
  Future<void> _generateQR() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse("${Constants.baseUrl}/qr/generate-qr"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
        body: jsonEncode({"company_id": widget.company['_id']}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        setState(() {
          qrValue = body['lGUID']; // Guardar valor del QR
          progress = 1.0; // Reinicia barra de progreso
        });

        // Cancelar temporizador previo si existe
        progressTimer?.cancel();

        // Inicia temporizador de 1 minuto para expirar QR
        const totalTime = 60 * 1000; 
        final startTime = DateTime.now();

        progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
          final elapsed = DateTime.now().difference(startTime).inMilliseconds;
          setState(() {
            progress = 1 - (elapsed / totalTime); // Actualiza barra
            if (progress <= 0) {
              progress = 0;
              qrValue = null; // QR expira
              timer.cancel();
            }
          });
        });
      } else {
        final body = jsonDecode(response.body);
        _showTemporaryMessage(body['message'] ?? "Error al generar QR");
      }
    } catch (e) {
      _showTemporaryMessage("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Alterna entre mostrar nombre de empresa o rol del usuario
  void _toggleMode() {
    setState(() => showCompanyName = !showCompanyName);
  }

  @override
  void dispose() {
    progressTimer?.cancel(); // Cancela temporizador al cerrar pantalla
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      // Previene salir si QR activo
      onWillPop: () async {
        _handleBackAction();
        return qrValue == null;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0b1014),
        body: Stack(
          children: [
            // Boton para volver
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: _handleBackAction,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0b1014),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                ),
              ),
            ),

            // Logo superior centrado
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/logo.png',
                width: 110,
                height: 150,
              ),
            ),

            // Barra de progreso del QR
            Positioned(
              top: 150,
              left: screenWidth / 2 - 110,
              child: QRProgressBar(progress: progress),
            ),

            // QR y mensaje de error
            Positioned(
              top: 170,
              left: screenWidth / 2 - 175,
              child: Column(
                children: [
                  QRCard(
                    qrValue: qrValue,
                    isLoading: isLoading,
                    onGenerate: _generateQR,
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),

            // Informacion del usuario
            Positioned(
              top: 600,
              left: 0,
              right: 0,
              child: QRUserInfo(user: widget.user),
            ),

            // Barra toggle nombre de empresa / rol usuario
            Positioned(
              top: 710,
              left: 15,
              right: 15,
              child: QRToggleBar(
                showCompanyName: showCompanyName,
                companyName: widget.company['name'] ?? '',
                userRole: widget.user['role'] ?? '',
                onToggle: _toggleMode,
              ),
            ),

            // Codigo de barras con ID del usuario
            UserBarcode(userId: widget.user['_id']),
          ],
        ),
      ),
    );
  }
}
