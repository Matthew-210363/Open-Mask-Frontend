
import 'package:go_router/go_router.dart';
import 'package:open_mask/pages/camera_page.dart';
import 'package:open_mask/pages/filter_workshop_page.dart';
import 'package:open_mask/pages/login_page.dart';
import 'package:open_mask/pages/register_page.dart';
import 'package:open_mask/pages/settings_page.dart';

final router = GoRouter(
  initialLocation: LoginPage.routePath,
  routes: [
    GoRoute(path: LoginPage.routePath, builder: (context, state) => LoginPage()),
    GoRoute(path: RegisterPage.routePath, builder: (context, state) => RegisterPage()),
    GoRoute(path: CameraPage.routePath, builder: (context, state) => CameraPage()),
    GoRoute(path: FilterWorkshopPage.routePath, builder: (context, state) => FilterWorkshopPage()),
    GoRoute(path: SettingsPage.routePath, builder: (context, state) => SettingsPage())
  ]
);