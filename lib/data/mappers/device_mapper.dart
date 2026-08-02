import '../../domain/entities/device_entity.dart';
import '../datasources/models/device_dto.dart';

/// DTO to entity translation for devices. Lives in the data layer so the
/// domain stays free of any knowledge of the wire format.
extension DeviceMapper on DeviceDto {
  DeviceEntity toEntity() => DeviceEntity(id: id, type: type);
}

extension DeviceListMapper on List<DeviceDto> {
  List<DeviceEntity> toEntities() => map((dto) => dto.toEntity()).toList();
}
