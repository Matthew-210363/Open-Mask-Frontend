
import 'package:open_mask/filter/configs/filter_config.dart';

class MustacheConfig extends FilterConfig {
  /// relative Position unter der Nase (0–1)
  final double offsetY;
  final String assetPath;
  final double relativeWidth;
  final double relativeHeight;

  static const String _standardAssetPath = 'assets/images/mustache.png';
  static const double _standardOffsetY = 20;
  static const double _standardRelativeWidth = 0.4;
  static const double _standardRelativeHeight = 0.4;

  MustacheConfig({
    required super.id,
    this.offsetY = _standardOffsetY,
    this.relativeWidth = 0.4,
    this.relativeHeight = 0.4,
    this.assetPath = _standardAssetPath,
  });

  @override
  Map<String, dynamic> toJSON() => {
    'id': id,
    'offsetY': offsetY,
    'assetPath': assetPath,
    'relativeWidth': relativeWidth,
    'relativeHeight': relativeHeight
  };

  factory MustacheConfig.fromJSON(Map<String, dynamic> json) => MustacheConfig(
    id: json['id'],
    offsetY: (json['offsetY'] ?? _standardOffsetY).toDouble(),
    assetPath: json['assetPath'] ?? _standardAssetPath,
    relativeWidth: (json['relativeWidth'] ?? _standardRelativeWidth).toDouble(),
    relativeHeight: (json['relativeHeight'] ?? _standardRelativeHeight).toDouble(),
  );
}