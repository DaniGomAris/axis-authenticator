import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'package:barcode_widget/barcode_widget.dart';

class QRPage extends StatefulWidget {
  final String token;
  final Map<String, dynamic> user;
  final Map<String, dynamic> company;

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
  String? qrValue;
  bool isLoading = false;
  Timer? qrTimer;
  Timer? progressTimer;
  double progress = 1.0;
  bool showCompanyName = true;
  String? errorMessage;

  // Mensaje temporal de 5 segundos
  void _showTemporaryMessage(String message) {
    setState(() {
      errorMessage = message;
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          errorMessage = null;
        });
      }
    });
  }

  // Función centralizada para manejar el "back"
  void _handleBackAction() {
    if (qrValue != null) {
      _showTemporaryMessage("No puedes salir hasta que el QR expire");
    } else {
      Navigator.pop(context);
    }
  }

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
          qrValue = body['lGUID'];
          progress = 1.0;
        });

        qrTimer?.cancel();
        progressTimer?.cancel();

        qrTimer = Timer(const Duration(seconds: 60), () {
          setState(() {
            qrValue = null;
            progress = 0.0;
          });
        });

        const totalTime = 60 * 1000;
        int elapsed = 0;
        progressTimer =
            Timer.periodic(const Duration(milliseconds: 100), (timer) {
          elapsed += 100;
          setState(() {
            progress = 1 - (elapsed / totalTime);
            if (progress <= 0) {
              progress = 0;
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
      setState(() {
        isLoading = false;
      });
    }
  }

  void _toggleMode(bool toCompany) {
    setState(() {
      showCompanyName = toCompany;
    });
  }

  @override
  void dispose() {
    qrTimer?.cancel();
    progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        _handleBackAction();
        return qrValue == null;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF121416),
        body: Stack(
          children: [
            // Flecha para volver a home
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: _handleBackAction,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6e947c),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'assets/images/logo.png',
                width: 110,
                height: 150,
              ),
            ),

            // Barra de progreso
            Positioned(
              top: 150,
              left: screenWidth / 2 - 110,
              child: Container(
                height: 3,
                width: 220,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF6e947c),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),

            // QR + mensaje temporal
            Positioned(
              top: 170,
              left: screenWidth / 2 - 175,
              child: Column(
                children: [
                  Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: qrValue != null
                        ? Center(
                            child: QrImageView(
                              data: qrValue!,
                              version: QrVersions.auto,
                              size: 310,
                            ),
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Stack(
                                  children: [
                                    QrImageView(
                                      data: "placeholder-qr",
                                      version: QrVersions.auto,
                                      size: 310,
                                      foregroundColor: Colors.grey[400],
                                    ),
                                    Positioned.fill(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 6, sigmaY: 6),
                                        child: Container(
                                            color:
                                                Colors.white.withOpacity(0)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: isLoading ? null : _generateQR,
                                borderRadius: BorderRadius.circular(50),
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: Center(
                                    child: isLoading
                                        ? const SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 5,
                                              color: Color(0xFF6e947c),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.autorenew,
                                            size: 80,
                                            color: Colors.black,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),

            // Nombre del usuario
            Positioned(
              top: 600,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "${widget.user['name'] ?? ''} ${widget.user['last_name1'] ?? ''} ${widget.user['last_name2'] ?? ''}"
                      .trim(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // ID del usuario
            Positioned(
              top: 640,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "CC: ${widget.user['_id']}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // Barra verde con nombre o rol
            Positioned(
              top: 710,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                color: Colors.white,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 60,
                      color: const Color(0xFF6e947c),
                      alignment: Alignment.center,
                      child: Text(
                        showCompanyName
                            ? (widget.company['name'] ?? '')
                            : (widget.user['role'] ?? ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_left,
                            color: Colors.white, size: 40),
                        onPressed: () => _toggleMode(!showCompanyName),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_right,
                            color: Colors.white, size: 40),
                        onPressed: () => _toggleMode(!showCompanyName),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Código de barras
            Positioned(
              top: 820,
              left: screenWidth / 2 - 150,
              child: BarcodeWidget(
                barcode: Barcode.code128(),
                data: widget.user['_id'],
                width: 300,
                height: 50,
                drawText: false,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
