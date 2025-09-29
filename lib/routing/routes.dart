import 'package:go_router/go_router.dart';
import 'package:open_mask/ui/screens/camera_page.dart';
import 'package:open_mask/ui/screens/filter_workshop_page.dart';
import 'package:open_mask/ui/screens/login_page.dart';
import 'package:open_mask/ui/screens/register_page.dart';
import 'package:open_mask/ui/screens/settings_page.dart';

final router = GoRouter(initialLocation: LoginPage.routePath, routes: [
  GoRoute(path: LoginPage.routePath, builder: (context, state) => LoginPage()),
  GoRoute(
      path: RegisterPage.routePath,
      builder: (context, state) => RegisterPage()),
  GoRoute(
      path: CameraPage.routePath, builder: (context, state) => CameraPage()),
  GoRoute(
      path: FilterWorkshopPage.routePath,
      builder: (context, state) => FilterWorkshopPage()),
  GoRoute(
      path: SettingsPage.routePath, builder: (context, state) => SettingsPage())
]);
