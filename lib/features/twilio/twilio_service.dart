import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/constants.dart';
import '../../../core/services/messages_service.dart';

// Servicio para manejo de OTP via Twilio
class TwilioService {

  // Envia un OTP al telefono proporcionado
  // Retorna un mapa con exito y mensaje
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final url = Uri.parse("${Constants.baseUrl}/twilio/send-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone}), // Envia el telefono al backend
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": data["success"] ?? false,
          "message": data["message"] ?? MessagesService.otpSendFailed
        };
      } else {
        return {
          "success": false,
          "message":
              "${MessagesService.otpSendFailed} (Error ${response.statusCode})"
        };
      }
    } catch (e) {
      print("Error sending OTP: $e"); // Log de error en consola
      return {
        "success": false,
        "message": MessagesService.networkError
      };
    }
  }

  // Verifica un OTP enviado al telefono
  // Retorna un mapa con exito y mensaje
  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final url = Uri.parse("${Constants.baseUrl}/twilio/verify-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone, "otp": otp}), // Envia telefono y OTP al backend
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "success": data["success"] ?? false,
          "message": data["message"] ?? MessagesService.otpVerifyFailed
        };
      } else {
        return {
          "success": false,
          "message":
              "${MessagesService.otpVerifyFailed} (Error ${response.statusCode})"
        };
      }
    } catch (e) {
      print("Error verifying OTP: $e"); // Log de error en consola
      return {
        "success": false,
        "message": MessagesService.networkError
      };
    }
  }
}
