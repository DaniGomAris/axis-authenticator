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

  // Enviar OTP (para recuperación de contraseña)
  static Future<bool> sendOtp(String phoneOrEmail) async {
    final url = "${Constants.baseUrl}/auth/send-otp"; // ajusta a tu endpoint real

    final response = await BaseService.post(
      url,
      {"identifier": phoneOrEmail}, // puede ser teléfono o correo
      null,
      defaultErrorMessage: MessagesService.otpSendFailed,
    );

    return response["success"] == true;
  }

  // Verificar OTP
  static Future<bool> verifyOtp(String phoneOrEmail, String otp) async {
    final url = "${Constants.baseUrl}/auth/verify-otp";

    final response = await BaseService.post(
      url,
      {"identifier": phoneOrEmail, "otp": otp},
      null,
      defaultErrorMessage: MessagesService.otpVerifyFailed,
    );

    return response["success"] == true;
  }

  // Cambiar contraseña (requiere OTP previamente verificado en backend)
  static Future<bool> changePassword(String phoneOrEmail, String password, String rePassword) async {
    final url = "${Constants.baseUrl}/user/change-password/$phoneOrEmail";

    final response = await BaseService.post(
      url,
      {"password": password, "rePassword": rePassword},
      null,
      defaultErrorMessage: MessagesService.passwordChangeFailed,
    );

    return response["success"] == true;
  }
}

