// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_level_range.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerLevelRangeAdapter extends TypeAdapter<PlayerLevelRange> {
  @override
  final int typeId = 1;

  @override
  PlayerLevelRange read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerLevelRange(
      startIndex: fields[0] as int,
      endIndex: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerLevelRange obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.startIndex)
      ..writeByte(1)
      ..write(obj.endIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerLevelRangeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
