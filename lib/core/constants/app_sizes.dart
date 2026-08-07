class AppSizes {
  static const font = _Font();
  static const spacing = _Spacing();
  static const padding = _Padding();
}

class _Font {
  const _Font();

  final double titleLarge = 24;
  final double titleSmall = 20;

  final double bodyLarge = 16;
  final double bodySmall = 14;
}

class _Spacing {
  const _Spacing();

  final double large = 32;
  final double medium = 24;
  final double small = 16;
  final double smallest = 8;
}

class _Padding {
  const _Padding();

  final double large = 32;
  final double medium = 16;
  final double small = 12;
  final double smallest = 8;
}
