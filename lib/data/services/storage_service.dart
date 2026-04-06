import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:open_mask/data/model/image_mime_type.dart';
import 'package:open_mask/data/services/auth_service.dart';
import 'package:path_provider/path_provider.dart';

import 'image_service.dart';

/// Service zur Verwaltung des Zugriffs auf den Speicher.
class StorageService {
  /// Privater Konstruktor für das Singleton-Pattern.
  StorageService._internal();

  /// Singleton-Instanz.
  static final StorageService instance = StorageService._internal();

  /// Pfad zum internen App-Speicher für Benutzerdateien.
  Directory? _docsDir;

  /// Ordner für alle Dateien des aktuellen Nutzers.
  Directory get _userDir => Directory(
      '${_docsDir!.path}/users/${AuthService.instance.user?.id ?? ''}');

  /// Ordner für die Photos des aktuellen Nutzers.
  Directory get _userPhotosDir => Directory('${_userDir.path}/photos');

  /// Ordner für die Filtersammlung des aktuellen Nutzers.
  Directory get _userFiltersDir => Directory('${_userDir.path}/filters');

  /// Geht sicher, dass der Ordner existiert.
  Future<Directory> _ensureDirExists(final Directory dir) async {
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// Speichert ein aufgenommenes Foto ([picture]) in die App-Galerie unter dem Namen [filename].
  Future<File> savePhotoToAppGallery(
      final XFile picture, final String filename) async {
    _docsDir ??= await getApplicationDocumentsDirectory();
    final dir = await _ensureDirExists(_userPhotosDir);
    final file = File('${dir.path}/$filename');
    return File(picture.path).copy(file.path);
  }

  /// Speichert das übergebene [image] in die App-Galerie mit dem angegebenen [filename].
  Future<File> saveUiImageToAppGallery(
      final ui.Image image, final String filename) async {
    _docsDir ??= await getApplicationDocumentsDirectory();
    final dir = await _ensureDirExists(_userPhotosDir);
    final File file = File('${dir.path}/$filename');
    return ImageService.saveUiImageToFile(image, file);
  }

  /// Listet die Fotodateien aus der App-Galerie auf.
  Future<List<File>> loadLocalPhotos() async {
    _docsDir ??= await getApplicationDocumentsDirectory();
    final dir = await _ensureDirExists(_userPhotosDir);
    final files = Directory(dir.path)
        .listSync()
        .whereType<File>()
        .where((final file) => ImageMimeType.values
            .map((final ImageMimeType mimeType) => mimeType.extension)
            .contains(file.path.split('.').last))
        .toList()
      ..sort((final a, final b) => b.path.compareTo(a.path)); // neueste zuerst

    return files;
  }
}
