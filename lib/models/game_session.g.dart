// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameSessionAdapter extends TypeAdapter<GameSession> {
  @override
  final int typeId = 5;

  @override
  GameSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameSession(
      id: fields[0] as String,
      gameTitle: fields[1] as String?,
      courtName: fields[2] as String,
      schedules: (fields[3] as List).cast<CourtSchedule>(),
      courtRate: fields[4] as double,
      shuttleCockPrice: fields[5] as double,
      divideCourtEqually: fields[6] as bool,
      createdAt: fields[7] as DateTime,
      playerIds: fields[8] != null ? (fields[8] as List).cast<String>() : const [],
    );
  }

  @override
  void write(BinaryWriter writer, GameSession obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gameTitle)
      ..writeByte(2)
      ..write(obj.courtName)
      ..writeByte(3)
      ..write(obj.schedules)
      ..writeByte(4)
      ..write(obj.courtRate)
      ..writeByte(5)
      ..write(obj.shuttleCockPrice)
      ..writeByte(6)
      ..write(obj.divideCourtEqually)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.playerIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
