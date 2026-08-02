/// Small string helpers used for labels and log formatting.
extension StringExt on String {
  /// `hello` becomes `Hello`. Leaves an empty string alone.
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// `device_name` or `deviceName` becomes `Device Name`.
  String toPascalCase() {
    if (isEmpty) return this;
    final words = replaceAllMapped(
      RegExp('([a-z0-9])([A-Z])'),
      (m) => '${m[1]} ${m[2]}',
    ).split(RegExp(r'[_\-\s]+')).where((w) => w.isNotEmpty);
    return words.map((w) => w.capitalize()).join(' ');
  }

  /// `deviceName` or `Device Name` becomes `device_name`.
  String toSnakeCase() {
    if (isEmpty) return this;
    return replaceAllMapped(
          RegExp('([a-z0-9])([A-Z])'),
          (m) => '${m[1]}_${m[2]}',
        )
        .replaceAll(RegExp(r'[\s\-]+'), '_')
        .toLowerCase();
  }

  /// Cuts to [max] characters and appends an ellipsis when longer.
  String truncate(int max) => length <= max ? this : '${substring(0, max)}...';
}

/// Helpers for values that may be absent or blank.
extension NullableStringExt on String? {
  bool get isBlank => this == null || this!.trim().isEmpty;

  String orDefault(String fallback) => isBlank ? fallback : this!;
}
