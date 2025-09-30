import 'dart:async';
import 'dart:convert';
import 'dart:ui'; // para el blur
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'package:barcode_widget/barcode_widget.dart';

class QRPage extends StatefulWidget {
  final String token;
  final String userId;
  final Map<String, dynamic> company;

  const QRPage({
    super.key,
    required this.token,
    required this.userId,
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

  Future<void> _generateQR() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("${Constants.baseUrl}/qr/generate-qr"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
        body: jsonEncode({
          "company_id": widget.company['_id'],
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        setState(() {
          qrValue = body['lGUID'];
          progress = 1.0;
        });

        qrTimer?.cancel();
        progressTimer?.cancel();

        // Timer de expiración del QR
        qrTimer = Timer(const Duration(seconds: 60), () {
          setState(() {
            qrValue = null;
            progress = 0.0;
          });
        });

        // Timer de progreso
        const totalTime = 60 * 1000; // 60 segundos
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'] ?? "Error al generar QR")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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

    return Scaffold(
      backgroundColor: const Color(0xFF121416),
      body: Stack(
        children: [
          // Barra delgada de progreso
          Positioned(
            top: 130,
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

          // QR
          Positioned(
            top: 150,
            left: screenWidth / 2 - 175,
            child: Container(
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
                                    sigmaX: 6,
                                    sigmaY: 6,
                                  ),
                                  child: Container(
                                    color: Colors.white.withOpacity(0),
                                  ),
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
          ),

          // ID
          Positioned(
            top: 650,
            left: screenWidth / 2 - 50,
            child: Text(
              "ID: ${widget.userId}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),

          // Línea verde con nombre de la empresa
          Positioned(
            top: 720,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 60,
                  color: const Color(0xFF6e947c),
                ),
                Text(
                  widget.company['name'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Código de barras
          Positioned(
            top: 830,
            left: screenWidth / 2 - 150,
            child: Container(
              child: BarcodeWidget(
                barcode: Barcode.code128(),
                data: widget.userId,
                width: 300,
                height: 50,
                drawText: false,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
