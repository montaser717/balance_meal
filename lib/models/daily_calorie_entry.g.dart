// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_calorie_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyCalorieEntryAdapter extends TypeAdapter<DailyCalorieEntry> {
  @override
  final int typeId = 6;

  @override
  DailyCalorieEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyCalorieEntry(
      date: fields[0] as DateTime,
      consumed: fields[1] as double,
      goal: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailyCalorieEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.consumed)
      ..writeByte(2)
      ..write(obj.goal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyCalorieEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
