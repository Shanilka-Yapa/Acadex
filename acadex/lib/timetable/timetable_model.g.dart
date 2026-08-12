// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timetable_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimetableModuleAdapter extends TypeAdapter<TimetableModule> {
  @override
  final typeId = 6;

  @override
  TimetableModule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimetableModule(
      semesterNo: (fields[0] as num).toInt(),
      code: fields[1] as String,
      name: fields[2] as String,
      colorValue: (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, TimetableModule obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.semesterNo)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimetableModuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TimetableSlotAdapter extends TypeAdapter<TimetableSlot> {
  @override
  final typeId = 7;

  @override
  TimetableSlot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimetableSlot(
      moduleKey: (fields[0] as num).toInt(),
      day: fields[1] as String,
      startTime: fields[2] as DateTime,
      endTime: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TimetableSlot obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.moduleKey)
      ..writeByte(1)
      ..write(obj.day)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimetableSlotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
