/// Uniform downsampling for graph data.
class DataSampler {
  const DataSampler._();

  /// Reduces [data] to exactly [targetCount] evenly spaced items.
  ///
  /// A 12-hour window at one reading per minute is 720 points, far more than a
  /// phone-sized chart can show. Stepping across the list keeps the shape of
  /// the curve while cutting the point count, and anchoring on
  /// `length - 1 / targetCount - 1` guarantees the first and last readings both
  /// survive so the chart still spans the full requested window.
  ///
  /// Returns [data] unchanged when it already holds [targetCount] items or
  /// fewer. No averaging happens, so every returned item is a real reading.
  static List<T> uniformSample<T>(List<T> data, int targetCount) {
    if (targetCount < 2) {
      throw ArgumentError.value(targetCount, 'targetCount', 'must be >= 2');
    }
    if (data.length <= targetCount) return data;

    final step = (data.length - 1) / (targetCount - 1);
    return List<T>.generate(
      targetCount,
      (i) => data[(i * step).round().clamp(0, data.length - 1)],
      growable: false,
    );
  }
}
