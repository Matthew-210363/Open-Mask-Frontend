import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

import 'image_service.dart';

/// Service zur Verwaltung des Zugriffs auf den Speicher.
class StorageService {
  /// Privater Konstruktor für das Singleton-Pattern.
  StorageService._internal();

  /// Singleton-Instanz.
  static final StorageService instance = StorageService._internal();

  /// Liefert den Galerie-Ordner der App zurück bzw. erstellt diesen, wenn nötig.
  Future<Directory> getAppGalleryDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final galleryDir = Directory('${dir.path}/photos');

    if (!await galleryDir.exists()) {
      await galleryDir.create(recursive: true);
    }

    return galleryDir;
  }

  /// Speichert ein aufgenommenes Foto ([picture]) in die App-Galerie unter dem Namen [filename].
  Future<File> savePhotoToAppGallery(
      final XFile picture, final String filename) async {
    final dir = await getAppGalleryDirectory();
    final file = File('${dir.path}/$filename');
    return File(picture.path).copy(file.path);
  }

  /// Speichert das übergebene [image] in die App-Galerie mit dem angegebenen [filename].
  Future<File> saveUiImageToAppGallery(
      final ui.Image image, final String filename) async {
    final dir = await getAppGalleryDirectory();
    final File file = File('${dir.path}/$filename');
    return ImageService.saveUiImageToFile(image, file);
  }

  /// Lädt Fotos aus der App-Galerie.
  Future<List<File>> loadLocalPhotos() async {
    final dir = await getAppGalleryDirectory();
    final files = Directory(dir.path)
        .listSync()
        .whereType<File>()
        .where((final file) =>
            file.path.endsWith('.png') || file.path.endsWith('.jpg'))
        .toList()
      ..sort((final a, final b) => b.path.compareTo(a.path)); // neueste zuerst

    return files;
  }
}
