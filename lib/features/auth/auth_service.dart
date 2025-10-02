import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/utils/constants.dart';
import '../../../core/services/base_service.dart';
import '../../../core/services/messages_service.dart';

class AuthService {
  // Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = "${Constants.baseUrl}/auth/login";
    return await BaseService.post(
      url,
      {"email": email, "password": password},
      null,
      defaultErrorMessage: MessagesService.loginFailed,
    );
  }
  
  // Logout
  static Future<Map<String, dynamic>> logout(String token) async {
    final url = "${Constants.baseUrl}/auth/logout";
    return await BaseService.post(
      url,
      {},
      token,
      defaultErrorMessage: MessagesService.logoutFailed,
    );
  }

  // Verificar token y obtener token renovado si existe
  static Future<Map<String, dynamic>> verifyToken(String token) async {
    try {
      final url = "${Constants.baseUrl}/auth/verify-token";

      // Hacemos la petición manual para leer los headers
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // Si el backend mandó un token nuevo en el header
        final newToken = response.headers['x-new-token'];

        return {
          "valid": body['valid'] == true,
          "token": newToken ?? token,
        };
      } else {
        return {"valid": false, "token": token};
      }
    } catch (_) {
      return {"valid": false, "token": token};
    }
  }
}
