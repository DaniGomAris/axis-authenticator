import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/utils/constants.dart';
import '../../../core/services/messages_service.dart';

class TwilioService {
  // Enviar OTP
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final url = Uri.parse("${Constants.baseUrl}/twilio/send-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone}),
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
      print("Error sending OTP: $e");
      return {
        "success": false,
        "message": MessagesService.networkError
      };
    }
  }

  // Verificar OTP
  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final url = Uri.parse("${Constants.baseUrl}/twilio/verify-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phone, "otp": otp}),
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
      print("Error verifying OTP: $e");
      return {
        "success": false,
        "message": MessagesService.networkError
      };
    }
  }
}
