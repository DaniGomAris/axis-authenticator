import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/utils/constants.dart';
import '../../../core/services/base_service.dart';
import '../../../core/services/messages_service.dart';

// Servicio para autenticacion: login, logout y verificacion de token
class AuthService {
  // Realiza login con email y password
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = "${Constants.baseUrl}/auth/login";
    return await BaseService.post(
      url,
      {"email": email, "password": password}, // Datos enviados
      null, // No se necesita token
      defaultErrorMessage: MessagesService.loginFailed, // Mensaje por defecto si falla
    );
  }
  
  // Cierra sesion usando el token
  static Future<Map<String, dynamic>> logout(String token) async {
    final url = "${Constants.baseUrl}/auth/logout";
    return await BaseService.post(
      url,
      {}, // No hay body necesario
      token,
      defaultErrorMessage: MessagesService.logoutFailed,
    );
  }

  // Verifica si el token es valido y retorna token renovado si aplica
  static Future<Map<String, dynamic>> verifyToken(String token) async {
    try {
      final url = "${Constants.baseUrl}/auth/verify-token";

      // Peticion GET manual para poder leer headers
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // Verifica si el backend envio un token nuevo
        final newToken = response.headers['x-new-token'];

        return {
          "valid": body['valid'] == true,
          "token": newToken ?? token, // Retorna token nuevo o actual
        };
      } else {
        return {"valid": false, "token": token};
      }
    } catch (_) {
      // En caso de error de red o parsing
      return {"valid": false, "token": token};
    }
  }
}
