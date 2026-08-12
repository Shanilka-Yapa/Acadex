// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gpa_module_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GpaModuleAdapter extends TypeAdapter<GpaModule> {
  @override
  final typeId = 4;

  @override
  GpaModule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GpaModule(
      semesterKey: (fields[0] as num).toInt(),
      moduleCode: fields[1] as String,
      moduleName: fields[2] as String,
      credits: (fields[3] as num).toDouble(),
      grade: fields[4] as String,
      isGpa: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GpaModule obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.semesterKey)
      ..writeByte(1)
      ..write(obj.moduleCode)
      ..writeByte(2)
      ..write(obj.moduleName)
      ..writeByte(3)
      ..write(obj.credits)
      ..writeByte(4)
      ..write(obj.grade)
      ..writeByte(5)
      ..write(obj.isGpa);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GpaModuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
