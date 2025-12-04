import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:open_mask/data/services/image_service.dart';
import 'package:open_mask/ui/screens/camera_screen.dart';
import 'package:open_mask/ui/view_models/camera_view_model.dart';
import 'package:open_mask/ui/views/face_markings_view.dart';
import 'package:open_mask/ui/views/filter_view.dart';
import 'package:open_mask/ui/widgets/camera_shutter_button.dart';
import 'package:open_mask/ui/widgets/face_markings_list_tile.dart';
import 'package:open_mask/ui/widgets/gallery_popup.dart';
import 'package:provider/provider.dart';

/// View, welches die UI für die Kameraanzeige selbst enthält und für [CameraScreen] bereitstellt. Nutzt [CameraViewModel] für Logik.
class CameraView extends StatelessWidget {
  /// Standard-Konstruktor.
  const CameraView({super.key});

  @override
  Widget build(final BuildContext context) {
    final CameraViewModel vm = context.watch<CameraViewModel>();

    if (!vm.cameraLive) {
      return const Center(child: CircularProgressIndicator());
    }

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: (vm.changingCamera || !vm.cameraService.cameraLive)
                ? const CircularProgressIndicator()
                : CameraPreview(vm.cameraService.cameraController!),
          ),
          Center(
            child: FaceMarkingsView(
              showMarkings: vm.showMarkings,
              showFaceBox: vm.showFaceBox,
              showLandmarks: vm.showLandmarks,
              showContours: vm.showContours,
            ),
          ),
          if (vm.filter != null && vm.filterActive)
            Center(child: FilterView(vm.filter!)),

          // --- Buttons Overlay ---
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Linker Button
                GestureDetector(
                    onTap: () => _openOtherOptionsSelection(context, vm),
                    child: Icon(Icons.photo_library,
                        color: ButtonTheme.of(context).colorScheme?.primary,
                        size: 28)),

                // TODO: ausgewählten Filter anzeigen & Filter auswählen
                // Auslöse-Button
                CameraShutterButton(
                    onTap: vm.takePicture, onLongPress: vm.switchFilterActive),

                // Rechter Button
                GestureDetector(
                    onTap: vm.switchLiveCamera,
                    child: Icon(Icons.cameraswitch,
                        color: ButtonTheme.of(context).colorScheme?.primary,
                        size: 28)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Öffnet eine Auswahl für weitere Optionen wie zur Öffnung der Galerie von gemachten Fotos, zum Ein- und Ausschalten bestimmter Funktionen, etc.
  void _openOtherOptionsSelection(
      final BuildContext context, final CameraViewModel vm) {
    showModalBottomSheet(
      context: context,
      builder: (final _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('App-Galerie anzeigen'),
              onTap: () => _openGalleryPopup(context),
            ),
            ListTile(
              leading: const Icon(Icons.photo_filter),
              title: const Text('Filter auswählen'),
              onTap: () {},
            ),
            FaceMarkingsListTile(viewModel: vm),
          ],
        );
      },
    );
  }

  /// Lädt die Photos mit [ImageService.loadLocalPhotos] und öffnet das Galerie-Popup ([GalleryPopup]).
  Future<void> _openGalleryPopup(final BuildContext context) async {
    final photos = await ImageService.loadLocalPhotos();
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierColor: Theme.of(context).colorScheme.surface.withAlpha(138),
      // Hintergrund abdunkeln, Kamera bleibt sichtbar
      builder: (final _) => Center(
        child: GalleryPopup(photos: photos),
      ),
    );
  }
}
