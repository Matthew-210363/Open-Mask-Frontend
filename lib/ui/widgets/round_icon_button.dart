import 'package:flutter/material.dart';

/// Knopf mit Icon und rundem Hintergrund.
class RoundIconButton extends StatelessWidget {
  /// Standard-Konstruktor.
  const RoundIconButton(
      {super.key,
      this.size = const Size(40, 40),
      required this.icon,
      required this.onTap});

  /// Gibt die Größe des Kreises an.
  final Size size;

  /// Icon, welches im Knopf angezeigt werden soll.
  final IconData icon;

  /// Gibt an, welche Aktion ausgeführt werden soll, wenn auf den Knopf gedrückt wird.
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(2),
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Icon(
                icon,
                size: size.width * 0.8,
                color: theme.colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
