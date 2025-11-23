import 'package:flutter/material.dart';
import 'package:open_mask/routing/active_branch_notifier.dart';
import 'package:open_mask/ui/view_models/camera_view_model.dart';
import 'package:open_mask/ui/views/camera_view.dart';
import 'package:provider/provider.dart';

/// Seite, die die Kamera und Filterverwendung enthält. Die Kamera-UI ist in [CameraView] und die Logik in [CameraViewModel].
/// <ul>
///   <li>Enthält Routeninformationen über die Seite ([routePath]/[cameraBranchIndex]).</li>
///   <li>Verwaltet das zugehörige [CameraViewModel] und [CameraView].</li>
///   <li>Reagiert über den [ActiveBranchNotifier] auf Tab-Wechsel.</li>
///   <li>Startet/Stoppt die Kamera je nach Sichtbarkeit der Seite.</li>
/// </ul>
class CameraScreen extends StatefulWidget {
  /// Standard-Konstruktor.
  const CameraScreen({super.key});

  /// Route zu der Seite, über die diese erreicht werden kann.
  static const routePath = '/camera';

  /// Gibt den Index des Kamera-Tabs für das Shell-Routing an.
  static const int cameraBranchIndex = 1;

  @override
  State<StatefulWidget> createState() => _CameraScreenState();
}

/// Hält den Status des [CameraScreen].
class _CameraScreenState extends State<CameraScreen> {
  /// Das ViewModel, das die Kameralogik im aktuellen Zustand verwaltet.
  late final CameraViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = CameraViewModel(context);
    viewModel.pageVisible = true;

    ActiveBranchNotifier.instance.addListener(_onBranchChanged);

    WidgetsBinding.instance
        .addPostFrameCallback((final _) => _onBranchChanged());
  }

  /// Wird aufgerufen, wenn sich der aktive Branch ändert. <br>
  /// Startet oder stoppt die Kamera abhängig davon, ob die Seite aktiv ist.
  void _onBranchChanged() {
    final isActive =
        ActiveBranchNotifier.instance.value == CameraScreen.cameraBranchIndex;

    if (isActive) {
      if (!viewModel.initialized) {
        viewModel.initialize();
      } else {
        viewModel.startCamera();
      }
      viewModel.pageVisible = true;
    } else {
      if (viewModel.cameraLive) viewModel.stopCamera();
      viewModel.pageVisible = false;
    }
  }

  @override
  void dispose() {
    ActiveBranchNotifier.instance.removeListener(_onBranchChanged);
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return ChangeNotifierProvider.value(
        value: viewModel, child: const CameraView());
  }
}
