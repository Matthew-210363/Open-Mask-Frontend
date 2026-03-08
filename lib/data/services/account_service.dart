import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_mask/data/constants.dart';
import 'package:open_mask/data/services/auth_service.dart';
import 'package:open_mask/data/services/snackbar_service.dart';

/// Service zur Durchführung von Konto-Operationen
/// wie dem Bearbeiten von Attributen oder dem Löschen des Accounts.
class AccountService {
  static Future<void> editName(final BuildContext context) async {}

  static Future<void> editUsername(BuildContext context) async {}

  static Future<void> resetEmail(BuildContext context) async {}

  static Future<void> resetPassword(BuildContext context) async {}

  static Future<void> changePassword(BuildContext context) async {}

  static Future<File?> changeProfilepicture() async {
    File? _imageFile;
    /* TODO: Image Picker kompatible Version finden
    final ImagePicker _picker = ImagePicker();


    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      return _imageFile;
    }*/
    return null;
  }

  /// Löscht den gerade eingeloggten Benutzer [AuthService.user] und meldet ihn mit [AuthService.logout] ab.
  /// Gibt zurück, ob der Benutzer erfolgreich gelöscht wurde, oder nicht.
  static Future<bool> deleteAccount() async {
    if (AuthService.instance.user == null) {
      return false;
    }
    int id = AuthService.instance.user!.id;

    if (AuthService.instance.user?.id == null) {
      return false;
    }

    var url = Uri.https(
      apiBaseUrl,
      '$auth/delete/$id',
    );
    try {
      http.Response response = await http.delete(url);
      // print('deleteAccount (Benutzer: ${AuthService.instance.user!.id}): ${response.statusCode} ${response.reasonPhrase}');

      if (response.statusCode == 404) {
        SnackBarService.showMessage('Benutzer nicht gefunden!');
        return false;
      }
      if (response.statusCode != 200) {
        SnackBarService.showMessage(
            'Account-Löschung fehlgeschlagen! (Status-Code: ${response.statusCode} ${response.reasonPhrase})');
        return false;
      }
      return AuthService.instance.logout();
    } catch (e) {
      SnackBarService.showMessage('Fehler: $e');
      return false;
    }
  }
}
