// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserClass.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserClassAdapter extends TypeAdapter<UserClass> {
  @override
  final int typeId = 1;

  @override
  UserClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserClass(
      email: fields[0] as String?,
      name: fields[1] as String?,
      password: fields[2] as String?,
      timeStamp: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserClass obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.timeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
