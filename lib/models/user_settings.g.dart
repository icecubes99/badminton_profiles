// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsAdapter extends TypeAdapter<UserSettings> {
  @override
  final int typeId = 3;

  @override
  UserSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettings(
      defaultCourtName: fields[0] as String,
      defaultCourtRate: fields[1] as double,
      defaultShuttleCockPrice: fields[2] as double,
      divideCourtEqually: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettings obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.defaultCourtName)
      ..writeByte(1)
      ..write(obj.defaultCourtRate)
      ..writeByte(2)
      ..write(obj.defaultShuttleCockPrice)
      ..writeByte(3)
      ..write(obj.divideCourtEqually);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
