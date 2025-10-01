import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_service.dart';
import 'messages_service.dart';
import '../utils/constants.dart';

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

  // Cambiar contraseña (requiere OTP previamente verificado)
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
