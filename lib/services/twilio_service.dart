import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';
import 'messages_service.dart';
import '../utils/constants.dart';

class TwilioService {
  // Enviar OTP
  static Future<bool> sendOtp(String phone) async {
    final url = "${Constants.baseUrl}/twilio/send-otp";

    final response = await BaseService.post(
      url,
      {"phone": phone},
      null,
      defaultErrorMessage: MessagesService.otpSendFailed,
    );

    return response["success"] == true;
  }

  // Verificar OTP
  static Future<bool> verifyOtp(String phone, String otp) async {
    final url = "${Constants.baseUrl}/twilio/verify-otp";

    final response = await BaseService.post(
      url,
      {"phone": phone, "otp": otp},
      null,
      defaultErrorMessage: MessagesService.otpVerifyFailed,
    );

    return response["success"] == true;
  }
}
