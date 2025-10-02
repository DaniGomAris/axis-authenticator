import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/base_service.dart';
import '../../../core/services/messages_service.dart';
import '../../../core/utils/constants.dart';

// Servicio para manejo de usuarios y OTP
class UserService {

  // Obtener informacion completa del usuario por su id
  // Retorna un mapa con los datos del usuario
  static Future<Map<String, dynamic>> getUserInfo(String userId, String token) async {
    final url = "${Constants.baseUrl}/user/$userId";

    return await BaseService.get(
      url,
      token: token,
      defaultErrorMessage: MessagesService.unknownError, // Mensaje por defecto en caso de error
    );
  }

  // Enviar OTP al telefono
  // Retorna true si el envio fue exitoso
  static Future<bool> sendOtp(String phone) async {
    final url = "${Constants.baseUrl}/auth/send-otp"; 

    final response = await BaseService.post(
      url,
      {"identifier": phone}, // Envia el telefono como identificador
      null,
      defaultErrorMessage: MessagesService.otpSendFailed, // Mensaje por defecto si falla
    );

    return response["success"] == true;
  }

  // Verificar OTP recibido en el telefono
  // Retorna true si el OTP es valido
  static Future<bool> verifyOtp(String phone, String otp) async {
    final url = "${Constants.baseUrl}/auth/verify-otp";

    final response = await BaseService.post(
      url,
      {"identifier": phone, "otp": otp}, // Envia telefono y OTP
      null,
      defaultErrorMessage: MessagesService.otpVerifyFailed, // Mensaje por defecto si falla
    );

    return response["success"] == true;
  }

  // Cambiar la contraseña del usuario
  // Retorna true si la operacion fue exitosa
  static Future<bool> changePassword(String phone, String password, String rePassword) async {
    final url = "${Constants.baseUrl}/user/change-password/$phone";

    final response = await BaseService.post(
      url,
      {"password": password, "rePassword": rePassword}, // Envia nueva contraseña y confirmacion
      null,
      defaultErrorMessage: MessagesService.passwordChangeFailed, // Mensaje por defecto si falla
    );

    return response["success"] == true;
  }
}
