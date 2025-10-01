class MessagesService {
  // Errores de conexión o servidor
  static const String networkError = "No se pudo conectar con el servidor";
  static const String unknownError = "Ocurrió un error inesperado";

  // Auth
  static const String loginFailed = "Login fallido, verifica tus credenciales";
  static const String logoutFailed = "No se pudo cerrar sesión";
  static const String invalidToken = "Token inválido o expirado";

  // QR
  static const String qrAlreadyActive = "El código QR ya está activo, espere a que expire";
  static const String qrGenerationFailed = "No se pudo generar el QR";
  static const String qrNotFound = "QR no encontrado o expirado";
  static const String qrValidationFailed = "Validación de QR fallida";

  // Twilio / OTP
  static const String otpSendFailed = "Error al enviar el OTP";
  static const String otpVerifyFailed = "Error al verificar el OTP";

  // User / Password
  static const String passwordChangeFailed = "No se pudo cambiar la contraseña";
  static const String passwordMismatch = "Las contraseñas no coinciden";
  static const String passwordRequired = "Se requieren contraseña y repetir contraseña";

  // Otros
  static const String missingFields = "Por favor completa todos los campos";
  static const String accessDenied = "Acceso denegado";

  // Mensajes de éxito
  static const String loginSuccess = "Login exitoso";
  static const String logoutSuccess = "Logout exitoso";
  static const String qrGenerated = "QR generado correctamente";
  static const String qrValidated = "QR validado correctamente";
  static const String otpSent = "OTP enviado correctamente";
  static const String otpVerified = "OTP verificado correctamente";
  static const String passwordChanged = "Contraseña actualizada correctamente";
}
