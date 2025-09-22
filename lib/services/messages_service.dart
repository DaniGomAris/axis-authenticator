class MessagesService {
  // Errores de conexión o servidor
  static const String networkError = "No se pudo conectar con el servidor";
  static const String unknownError = "Ocurrió un error inesperado";

  // Auth
  static const String loginFailed = "Login fallido, verifica tus credenciales";
  static const String logoutFailed = "No se pudo cerrar sesión";
  static const String invalidToken = "Token inválido o expirado";

  // QR
  static const String qrGenerationFailed = "No se pudo generar el QR";
  static const String qrNotFound = "QR no encontrado o expirado";
  static const String qrValidationFailed = "Validación de QR fallida";

  // Otros
  static const String missingFields = "Por favor completa todos los campos";
  static const String accessDenied = "Acceso denegado";

  // Mensajes de éxito
  static const String loginSuccess = "Login exitoso";
  static const String logoutSuccess = "Logout exitoso";
  static const String qrGenerated = "QR generado correctamente";
  static const String qrValidated = "QR validado correctamente";
}
