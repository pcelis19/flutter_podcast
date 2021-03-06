// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_service.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemePacketAdapter extends TypeAdapter<ThemePacket> {
  @override
  final int typeId = 0;

  @override
  ThemePacket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemePacket.hive(fields[0], fields[1]);
  }

  @override
  void write(BinaryWriter writer, ThemePacket obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._flexScheme)
      ..writeByte(1)
      ..write(obj._themeMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemePacketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
