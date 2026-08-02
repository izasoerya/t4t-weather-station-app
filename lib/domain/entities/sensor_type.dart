/// The five measurements a weather station reports.
///
/// Order matters: the dashboard grid renders the cards in declaration order
/// (temperature, humidity, rainfall, wind speed, wind direction).
enum SensorType {
  temperature,
  humidity,
  rainfall,
  windSpeed,
  windDirection;

  /// Human-readable name shown on cards and in the graph dropdown.
  String get label => switch (this) {
        SensorType.temperature => 'Temperature',
        SensorType.humidity => 'Humidity',
        SensorType.rainfall => 'Rainfall',
        SensorType.windSpeed => 'Wind Speed',
        SensorType.windDirection => 'Wind Direction',
      };

  /// Compact label used in the horizontal sensor selector.
  String get shortLabel => switch (this) {
        SensorType.temperature => 'Tmp',
        SensorType.humidity => 'Hum',
        SensorType.rainfall => 'Rai',
        SensorType.windSpeed => 'WSp',
        SensorType.windDirection => 'WDr',
      };

  /// Unit suffix appended to the numeric value.
  String get unit => switch (this) {
        SensorType.temperature => '\u00B0C',
        SensorType.humidity => '%',
        SensorType.rainfall => 'mm/\nday',
        SensorType.windSpeed => 'km/h',
        SensorType.windDirection => '\u00B0',
      };

  /// Decimal places used when formatting the value.
  int get decimals => switch (this) {
        SensorType.temperature => 1,
        SensorType.humidity => 1,
        SensorType.rainfall => 1,
        SensorType.windSpeed => 1,
        SensorType.windDirection => 0,
      };

  /// Wind direction arrives as a cardinal string, so cards show text rather
  /// than a formatted number. The graph still plots its degree equivalent.
  bool get isCardinal => this == SensorType.windDirection;
}
