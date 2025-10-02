import 'dart:convert';
import 'package:http/http.dart' as http;
import 'messages_service.dart';

class BaseService {
  // Metodo para hacer peticiones POST
  // Recibe url, cuerpo de la peticion, token opcional y mensaje de error por defecto
  static Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
    String? token, {
    String defaultErrorMessage = MessagesService.unknownError,
  }) async {
    try {
      // Construir headers, agregando Authorization solo si hay token
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      // Revisar codigo de estado HTTP
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        final message = responseBody["message"] ?? defaultErrorMessage;
        final code = responseBody["code"] ?? "UNKNOWN_ERROR";
        // Lanzar excepcion personalizada con info del error
        throw ApiException(
          message: message,
          code: code,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      // Si ya es ApiException, relanzar
      if (e is ApiException) rethrow;

      // Manejo de error de red
      throw ApiException(
        message: MessagesService.networkError,
        code: "NETWORK_ERROR",
        statusCode: 0,
      );
    }
  }

  // Metodo para hacer peticiones GET
  // Recibe url, token opcional y mensaje de error por defecto
  static Future<Map<String, dynamic>> get(
    String url, {
    String? token,
    String defaultErrorMessage = MessagesService.unknownError,
  }) async {
    try {
      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.get(Uri.parse(url), headers: headers);

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else {
        final message = responseBody["message"] ?? defaultErrorMessage;
        final code = responseBody["code"] ?? "UNKNOWN_ERROR";
        throw ApiException(
          message: message,
          code: code,
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;

      throw ApiException(
        message: MessagesService.networkError,
        code: "NETWORK_ERROR",
        statusCode: 0,
      );
    }
  }
}

// Excepcion personalizada para manejar errores de API
class ApiException implements Exception {
  final String message;
  final String code;
  final int statusCode;

  ApiException({required this.message, required this.code, required this.statusCode});

  @override
  String toString() => message;
}
