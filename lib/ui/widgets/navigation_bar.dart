import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "package:open_mask/ui/screens/camera_page.dart";
import 'package:open_mask/ui/screens/filter_workshop_page.dart';
import 'package:open_mask/ui/screens/settings_page.dart';

class CustomNavigationBar extends StatelessWidget {
  final String currentRoute;

  const CustomNavigationBar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              icon: const Icon(Icons.flash_on, color: Colors.white, size: 30),
              onPressed: () => (currentRoute == FilterWorkshopPage.routePath)
                  ? {}
                  : context.pushReplacement(FilterWorkshopPage.routePath)),
          IconButton(
              icon: const Icon(Icons.circle_outlined,
                  color: Colors.white, size: 50),
              onPressed: () => (currentRoute == CameraPage.routePath)
                  ? {}
                  : context.pushReplacement(CameraPage.routePath)),
          IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 30),
              onPressed: () => (currentRoute == SettingsPage.routePath)
                  ? {}
                  : context.pushReplacement(SettingsPage.routePath)),
        ],
      ),
    );
  }
}
