import 'package:equatable/equatable.dart';

/// Wire format for a row of the `devices` table.
///
/// Field names mirror the Supabase columns. Nothing here knows about the app's
/// domain rules; `DeviceMapper` handles the translation.
class DeviceDto extends Equatable {
  const DeviceDto({required this.id, this.type});

  final int id;
  final String? type;

  factory DeviceDto.fromJson(Map<String, dynamic> json) => DeviceDto(
        id: (json['id'] as num).toInt(),
        type: json['type'] as String?,
      );

  Map<String, dynamic> toJson() => {'id': id, 'type': type};

  @override
  List<Object?> get props => [id, type];

  @override
  bool get stringify => true;
}
