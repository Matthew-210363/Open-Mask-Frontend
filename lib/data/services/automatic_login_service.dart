import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:open_mask/data/services/auth_service.dart';

/// Service zur Speicherung der Login-Daten und Durchführung des automatischen Logins.
class AutomaticLoginService {
  /// Privater Konstruktor für das Singleton-Pattern.
  AutomaticLoginService._internal();

  /// Singleton-Instanz.
  static final AutomaticLoginService instance =
      AutomaticLoginService._internal();

  /// Gibt an, ob die Benutzerdaten für die Zukunft gespeichert werden sollen,
  /// um eine automatische Anmeldung zu ermöglichen.
  bool _rememberMe = false;

  /// Gibt an, ob die Benutzerdaten für die Zukunft gespeichert werden sollen,
  /// um eine automatische Anmeldung zu ermöglichen.
  bool get rememberMe => _rememberMe;

  /// Konstante für die Verwendung des [FlutterSecureStorage].
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Speichert die Login-Daten lokal mit [FlutterSecureStorage].
  Future<void> saveLoginData(final String email, final String password) async {
    _rememberMe = true;

    await _secureStorage.write(key: 'email', value: email);
    await _secureStorage.write(key: 'password', value: password);
    await _secureStorage.write(key: 'rememberMe', value: 'true');
  }

  /// Löscht die Login-Daten.
  Future<void> clearLoginData() async {
    _rememberMe = false;

    await _secureStorage.delete(key: 'email');
    await _secureStorage.delete(key: 'password');
    await _secureStorage.write(key: 'rememberMe', value: 'false');
  }

  /// Meldet den Benutzer automatisch an.
  Future<void> autoLogin() async {
    String? remember = await _secureStorage.read(key: 'rememberMe');

    _rememberMe = remember == 'true';

    if (_rememberMe) {
      String email = await _secureStorage.read(key: 'email') ?? '';

      String password = await _secureStorage.read(key: 'password') ?? '';

      bool success = await AuthService.instance.login(email, password);

      if (!success) {
        await clearLoginData();
        return;
      }
    }
  }
}
