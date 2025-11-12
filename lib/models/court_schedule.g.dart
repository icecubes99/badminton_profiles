// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'court_schedule.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CourtScheduleAdapter extends TypeAdapter<CourtSchedule> {
  @override
  final int typeId = 4;

  @override
  CourtSchedule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourtSchedule(
      courtNumber: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CourtSchedule obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.courtNumber)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourtScheduleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
