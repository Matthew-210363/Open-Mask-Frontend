import 'package:flutter/cupertino.dart';
import 'package:open_mask/data/services/auth_service.dart';
import 'package:open_mask/data/services/snackbar_service.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> login(final String email, final String password) async {
    _isLoading = true;
    notifyListeners();

    // Überprüfung, ob E-Mail und Passwort ausgefüllt ist
    if (email.isEmpty || password.isEmpty) {
      SnackBarService.showMessage('Bitte E-Mail und Passwort angeben!');
    }

    AuthService.login(email, password);

    SnackBarService.showMessage('Login erfolgreich!');

    _isLoading = false;
    notifyListeners();
  }
}
