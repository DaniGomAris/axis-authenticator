import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/base_service.dart';
import '../../../core/services/messages_service.dart';
import '../../../core/utils/constants.dart';

class UserService {

  // Obtener info del usuario
  static Future<Map<String, dynamic>> getUserInfo(String userId, String token) async {
    final url = "${Constants.baseUrl}/user/$userId";

    return await BaseService.get(
      url,
      token: token,
      defaultErrorMessage: MessagesService.unknownError,
    );
  }

  // Enviar OTP
  static Future<bool> sendOtp(String phone) async {
    final url = "${Constants.baseUrl}/auth/send-otp"; 

    final response = await BaseService.post(
      url,
      {"identifier": phone}, 
      null,
      defaultErrorMessage: MessagesService.otpSendFailed,
    );

    return response["success"] == true;
  }

  // Verificar OTP
  static Future<bool> verifyOtp(String phone, String otp) async {
    final url = "${Constants.baseUrl}/auth/verify-otp";

    final response = await BaseService.post(
      url,
      {"identifier": phone, "otp": otp},
      null,
      defaultErrorMessage: MessagesService.otpVerifyFailed,
    );

    return response["success"] == true;
  }

  // Cambiar contraseña
  static Future<bool> changePassword(String phone, String password, String rePassword) async {
    final url = "${Constants.baseUrl}/user/change-password/$phone";

    final response = await BaseService.post(
      url,
      {"password": password, "rePassword": rePassword},
      null,
      defaultErrorMessage: MessagesService.passwordChangeFailed,
    );

    return response["success"] == true;
  }
}

