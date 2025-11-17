import 'dart:io';

import 'package:flutter/material.dart';

/// Popup, welches Bilder in einer Galerie anzeigt.
class GalleryPopup extends StatelessWidget {
  /// Standard-Konstruktor. <br>
  /// [photos] stellt die Liste der darzustellenden Fotos dar.
  const GalleryPopup({super.key, required final List<File> photos})
      : _photos = photos;

  /// Die Liste der darzustellenden Fotos.
  final List<File> _photos;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface, // Hintergrund aus Theme!
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Titel
            Text(
              'App-Galerie',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Gitter mit Bildern
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _photos.length,
                  itemBuilder: (final context, final index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_photos[index], fit: BoxFit.cover),
                    );
                  },
                ),
              ),
            ),

            // Close Button
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Schließen',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
