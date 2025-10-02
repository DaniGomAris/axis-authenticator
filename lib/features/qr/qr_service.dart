import '../../core/utils/constants.dart';
import '../../core/services/base_service.dart';
import '../../core/services/messages_service.dart';

// Servicio para manejo de QR
class QrService {

  // Genera un QR llamando al backend
  // Recibe token de usuario y opcionalmente el id de la empresa
  // Retorna el valor unico del QR (lGUID)
  static Future<String> generateQr(String token, {String? companyId}) async {
    final url = "${Constants.baseUrl}/qr/generate-qr";

    final response = await BaseService.post(
      url,
      {"company_id": companyId}, // Envia id de la empresa si existe
      token,
      defaultErrorMessage: MessagesService.qrGenerationFailed, // Mensaje por defecto en caso de error
    );

    print(MessagesService.qrGenerated); // Log para desarrollo
    return response["lGUID"];
  }

  // Valida un QR en el backend
  // Recibe token de usuario y valor unico del QR (lGUID)
  // Retorna la respuesta completa del backend
  static Future<Map<String, dynamic>> validateQr(String token, String lGUID) async {
    final url = "${Constants.baseUrl}/qr/validate-qr";

    final response = await BaseService.post(
      url,
      {"lGUID": lGUID}, // Envia el QR a validar
      token,
      defaultErrorMessage: MessagesService.qrValidationFailed, // Mensaje por defecto en caso de error
    );

    print(MessagesService.qrValidated); // Log para desarrollo
    return response;
  }
}
