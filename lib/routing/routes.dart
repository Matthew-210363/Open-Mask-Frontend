import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:open_mask/routing/app_shell.dart';
import 'package:open_mask/ui/screens/camera_screen.dart';
import 'package:open_mask/ui/screens/filter_workshop_screen.dart';
import 'package:open_mask/ui/screens/login_screen.dart';
import 'package:open_mask/ui/screens/register_screen.dart';
import 'package:open_mask/ui/screens/settings_screen.dart';

/// Navigationsschlüssel für den nicht authentifizierten Bereich der App.
final notAuthNavigatorKey = GlobalKey<NavigatorState>();

/// [GoRoute]-Liste mit drei Branches/Tabs zur Navigation in der App für nicht authentifizierte Benutzer.
/// <ul>
///   <li>Login-Seite</li>
///   <li>Registrierungs-Seite</li>
/// </ul>
final notAuthRoutes = [
  GoRoute(
      path: LoginScreen.routePath,
      builder: (final context, final state) => const LoginScreen()),
  GoRoute(
      path: RegisterScreen.routePath,
      builder: (final context, final state) => const RegisterScreen()),
];

/// Navigationsschlüssel für den Filterwerkstatt-Branch des authentifizierten Bereichs der App.
final _shellFilterWorkshopNavigatorKey = GlobalKey<NavigatorState>();

/// Navigationsschlüssel für den Filteranwendungs-Branch des authentifizierten Bereichs der App.
final _shellCameraNavigatorKey = GlobalKey<NavigatorState>();

/// Navigationsschlüssel für den Einstellungen-Branch des authentifizierten Bereichs der App.
final _shellSettingsNavigatorKey = GlobalKey<NavigatorState>();

/// [StatefulShellRoute] (in einer Liste als einzelnes Element) mit drei Branches/Tabs zur Navigation in der App für authentifizierte Benutzer.
/// <ul>
///   <li>FilterWorkshop (Tab 0)</li>
///   <li>Camera (Tab 1)</li>
///   <li>Settings (Tab 2)</li>
/// </ul>
/// Jeder Branch besitzt einen eigenen Navigator für unabhängige Stacks.
final authRoutes = [
  StatefulShellRoute.indexedStack(
      builder: (final context, final state, final navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        /// FilterWorkshop-Branch
        StatefulShellBranch(
            navigatorKey: _shellFilterWorkshopNavigatorKey,
            routes: [
              GoRoute(
                  path: FilterWorkshopScreen.routePath,
                  builder: (final context, final state) =>
                      const FilterWorkshopScreen(),
                  routes: [] // Erweiterbar um Sub-Pages mit Sub-Routen
                  ),
            ]),

        /// Kamera-Branch
        StatefulShellBranch(navigatorKey: _shellCameraNavigatorKey, routes: [
          GoRoute(
              path: CameraScreen.routePath,
              builder: (final context, final state) => const CameraScreen(),
              routes: [] // Erweiterbar um Sub-Pages mit Sub-Routen
              ),
        ]),

        /// Einstellungen-Branch
        StatefulShellBranch(navigatorKey: _shellSettingsNavigatorKey, routes: [
          GoRoute(
              path: SettingsScreen.routePath,
              builder: (final context, final state) => const SettingsScreen(),
              routes: [] // Erweiterbar um Sub-Pages mit Sub-Routen
              ),
        ])
      ])
];
