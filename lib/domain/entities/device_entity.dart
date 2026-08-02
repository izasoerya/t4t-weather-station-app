import 'package:equatable/equatable.dart';

/// A weather station, as the domain understands it.
///
/// Immutable and free of serialization concerns: `DeviceDto` handles the wire
/// format and the repository maps between the two.
class DeviceEntity extends Equatable {
  const DeviceEntity({required this.id, this.type});

  final int id;

  /// Hardware/firmware classification, e.g. `weather_station_v1`. Nullable
  /// because the backend column allows NULL.
  final String? type;

  /// Label used in the header and the device picker.
  String get displayName => 'Station $id';

  DeviceEntity copyWith({int? id, String? type}) =>
      DeviceEntity(id: id ?? this.id, type: type ?? this.type);

  @override
  List<Object?> get props => [id, type];

  @override
  bool get stringify => true;
}
