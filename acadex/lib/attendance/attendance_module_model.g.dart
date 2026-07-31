// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_module_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceModuleAdapter extends TypeAdapter<AttendanceModule> {
  @override
  final typeId = 1;

  @override
  AttendanceModule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceModule(
      moduleCode: fields[0] as String,
      moduleName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceModule obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.moduleCode)
      ..writeByte(1)
      ..write(obj.moduleName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceModuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
