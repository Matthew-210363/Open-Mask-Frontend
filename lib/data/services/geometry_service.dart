import 'dart:math';
import 'dart:ui';

/// Utility-Class für geometrische Operationen
class GeometryService {
  /// Dreht das angegebene Offset [offset] für ein Koordinatensystem mit invertiertem y, wie es von [Canvas] verwendet wird um den angegeben Winkel [angle] (Radiant/Bogenmaß).
  static Offset rotateOffset(final Offset offset, final double angle) {
    final rotatedOffsetX = offset.dx * cos(angle) + offset.dy * sin(angle);
    // x′ = x * cos(alpha) − y * sin(alpha)
    // --> sin umdrehen, weil y-Achso im Canvas invertiert ist (von oben nach unten)
    final rotatedOffsetY = offset.dx * sin(angle) + offset.dy * cos(angle);
    // y′ = x * sin(θ) + y * cos(θ)

    return Offset(rotatedOffsetX, rotatedOffsetY);
  }

  /// Berechnet den Mittelpunkt zwischen zwei Punkten.
  static Offset midpoint(final Offset a, final Offset b) =>
      Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
}
