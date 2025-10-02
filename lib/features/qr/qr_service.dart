import '../../core/utils/constants.dart';
import '../../core/services/base_service.dart';
import '../../core/services/messages_service.dart';

class QrService {
  static Future<String> generateQr(String token, {String? companyId}) async {
    final url = "${Constants.baseUrl}/qr/generate-qr";

    final response = await BaseService.post(
      url,
      {"company_id": companyId},
      token,
      defaultErrorMessage: MessagesService.qrGenerationFailed,
    );

    print(MessagesService.qrGenerated);
    return response["lGUID"];
  }

  static Future<Map<String, dynamic>> validateQr(String token, String lGUID) async {
    final url = "${Constants.baseUrl}/qr/validate-qr";

    final response = await BaseService.post(
      url,
      {"lGUID": lGUID},
      token,
      defaultErrorMessage: MessagesService.qrValidationFailed,
    );

    print(MessagesService.qrValidated);
    return response;
  }
}
